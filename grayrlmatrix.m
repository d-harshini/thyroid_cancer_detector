function [GLRLMS,SI]= grayrlmatrix(varargin)
[I, Offset, NL, GL] = ParseInputs(varargin{:});

% Scale I so that it contains integers between 1 and NL.
if GL(2) == GL(1)
    SI = ones(size(I));
else
    slope = (NL-1) / (GL(2) - GL(1));
    intercept = 1 - (slope*(GL(1)));
    SI = round(imlincomb(slope,I,intercept,'double'));
end

% Clip values if user had a value that is outside of the range, e.g., double
% image = [0 .5 2;0 1 1]; 2 is outside of [0,1]. The order of the following
% lines matters in the event that NL = 0.
SI(SI > NL) = NL;
SI(SI < 1) = 1;
% total numbers of direction
numOffsets = size(Offset,1);

if NL ~= 0
    % make direction matrix for all given directions
    for k = 1 : numOffsets
        GLRLMS{k} = computeGLRLM(SI,Offset(k),NL);
    end
else
    GLRLMS = [];
end

% --------------------------------------------------------------------
function oneGLRLM = computeGLRLM(si,offset,nl)
% For given direction, compute the run length matrix
switch offset
    case 1
        % 0 degree
        oneGLRLM = rle_0(si,nl);
    case 2
        % 45 degree
        seq = zigzag(si);
        oneGLRLM  = rle_45(seq,nl);
    case 3
        % 90 degree
        oneGLRLM = rle_0(si',nl);
    case 4
        % 135 degree
        seq = zigzag(fliplr(si));
        oneGLRLM = rle_45(seq,nl);
    otherwise
        error('Only 4 directions supported')
end


% --------------------------------------------------------------------
function [I, offset, nl, gl] = ParseInputs(varargin)
% parsing parameter checking
% Inputs must be max seven item
iptchecknargin(1,7,nargin,mfilename);
%
% Check I
I = varargin{1};
iptcheckinput(I,{'logical','numeric'},{'2d','real','nonsparse'}, ...
    mfilename,'I',1);
% ------------------------
% Assign Defaults
% -------------------------
% four directions 0, 45, 90,135
offset = [1;2;3;4];
%
if islogical(I)
    nl = 2;
else
    nl = 8;
end
gl = getrangefromclass(I);

% Parse Input Arguments
if nargin ~= 1

    paramStrings = {'Offset','NumLevels','GrayLimits'};

    for k = 2:2:nargin

        param = lower(varargin{k});
        inputStr = iptcheckstrs(param, paramStrings, mfilename, 'PARAM', k);
        idx = k + 1;  %Advance index to the VALUE portion of the input.
        if idx > nargin
            eid = sprintf('Images:%s:missingParameterValue', mfilename);
            msg = sprintf('Parameter ''%s'' must be followed by a value.', inputStr);
            error(eid,'%s', msg);
        end

        switch (inputStr)

            case 'Offset'

                offset = varargin{idx};
                iptcheckinput(offset,{'logical','numeric'},...
                    {'d','nonempty','integer','real'},...
                    mfilename, 'OFFSET', idx);
                % must be row vector 
                if size(offset,2) ~= 1
                    eid = sprintf('Images:%s:invalidOffsetSize',mfilename);
                    msg = 'OFFSET must be an n x 1 array.';
                    error(eid,'%s',msg);
                end
                offset = double(offset);

            case 'NumLevels'

                nl = varargin{idx};
                iptcheckinput(nl,{'logical','numeric'},...
                    {'real','integer','nonnegative','nonempty','nonsparse'},...
                    mfilename, 'NL', idx);
                if numel(nl) > 1
                    eid = sprintf('Images:%s:invalidNumLevels',mfilename);
                    msg = 'NL cannot contain more than one element.';
                    error(eid,'%s',msg);
                elseif islogical(I) && nl ~= 2
                    eid = sprintf('Images:%s:invalidNumLevelsForBinary',mfilename);
                    msg = 'NL must be two for a binary image.';
                    error(eid,'%s',msg);
                end
                nl = double(nl);

            case 'GrayLimits'

                gl = varargin{idx};
                iptcheckinput(gl,{'logical','numeric'},{'vector','real'},...
                    mfilename, 'GL', idx);
                if isempty(gl)
                    gl = [min(I(:)) max(I(:))];
                elseif numel(gl) ~= 2
                    eid = sprintf('Images:%s:invalidGrayLimitsSize',mfilename);
                    msg = 'GL must be a two-element vector.';
                    error(eid,'%s',msg);
                end
                gl = double(gl);
        end
    end
end
