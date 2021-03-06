// ###################################################################
// #### This file is part of the mathematics library project, and is
// #### offered under the licence agreement described on
// #### http://www.mrsoft.org/
// ####
// #### Copyright:(c) 2011, Michael R. . All rights reserved.
// ####
// #### Unless required by applicable law or agreed to in writing, software
// #### distributed under the License is distributed on an "AS IS" BASIS,
// #### WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// #### See the License for the specific language governing permissions and
// #### limitations under the License.
// ###################################################################


unit LinearAlgebraicEquations;

// ############################################
// #### Functions to solve linear algebraic equations
// ############################################

interface

uses SysUtils, Types, MatrixConst, OptimizedFuncs;

// solves the matrix A*X = B where A*x1=b1, A*x2=b2, ... A*xm=bm
// The function stores in A the inverse of A and B stores the result vectors
// A must be a square matrix (width*width) and B must be m*width.
function MatrixGaussJordanInPlace(A : PDouble; const LineWidthA : integer; B : PDouble; const LineWidthB : integer; width : integer;
                                  m : integer; const epsilon : double = 1e-20; progress : TLinEquProgress = nil) : TLinEquResult;

function MatrixGaussJordan(A : PDouble; const LineWidthA : integer; B : PDouble; const LineWidthB : integer;
                           invA : PDouble; const LineWidthInvA : integer; X : PDouble; const LineWidthX : integer;
                           width : integer; m : integer; const epsilon : double = 1e-20; progress : TLinEquProgress = nil) : TLinEquResult;

// interface functions (used in different parts - don't call them directly)
procedure LUSwap(A : PDouble; const LineWidthA : Integer; width : integer; k1, k2 : integer; indx : PIntegerArray; var parity : integer);
procedure LUBacksup(A : PDouble; width, height : integer; B : PDouble; const LineWidth : integer);

// inplace LU decomposition of the matrix A. Diagonal elements of the lower triangular matrix are set to one
// thus the diagonal elements of the resulting matrix A are composed from the upper diagonal elements only.
// The index records the row permutation effected by the partial pivoting.
function MatrixLUDecompInPlace(A : PDouble; const LineWidthA : Integer; width : integer; indx : PIntegerArray; progress : TLinEquProgress = nil) : TLinEquResult;
function MatrixLUDecomp(A : PDouble; const LineWidthA : integer; LUDecomp : PDouble; const LineWidthLU : integer; width : integer; indx : PIntegerArray; progress : TLinEquProgress = nil) : TLinEquResult; overload;
function MatrixLUDecomp(A : PDouble; const LineWidthA : integer; LUDecomp : PDouble; const LineWidthLU : integer; width : integer; progress : TLinEquProgress = nil) : TLinEquResult; overload;
procedure MatrixLUBackSubst(LUDecomp : PDouble; const LineWidthLU : integer; width : integer; const  indx : PIntegerArray; B : PDouble; const LineWidthB : integer; progress : TLinEquProgress = nil);

// inverse of a matrix by using the LU decomposition
function MatrixInverseInPlace(A : PDouble; const LineWidthA : integer; width : integer; progress : TLinEquProgress = nil) : TLinEquResult;

// Matrix determinant calculated from the LU decomposition. Returns zero in case of a singular matrix. Drawback is a double
// memory usage since the LU decomposition must be stored in a temporary matrix.
function MatrixDeterminant(A : PDouble; const LineWidthA : integer; width : integer; progress : TLinEquProgress = nil) : double;


// Matrix Line Equation Solver routines which are based on LU decomposition.
// note these functions use temporarily double the size of A memory.
// The result is stored in X. B and X must have the same size, also B may have
// more than one column.
function MatrixLinEQSolve(A : PDouble; const LineWidthA : integer; width : integer; B : PDouble; const LineWidthB : integer; X : PDouble; const LineWidthX : integer;
   Width2 : integer; const NumRefinments : integer = 0; progress : TLinEquProgress = nil) : TLinEquResult;


// Inplace svd decomposition of a Matrix A
// The output is the computation of A= U*W*V' whereas U is stored in A, and W is a vector 0..Width-1. The matrix V (not V') must be as large as Width*Width!
function MatrixSVDInPlace(A : PDouble; const LineWidthA : integer; width : integer; Height : integer; W : PDouble; const LineWidthW : integer;
                           V : PDouble; const LineWidthV : integer; progress : TLinEquProgress = nil) : TSVDResult;
function MatrixSVD(A : PDouble; const LineWidthA : integer; width : integer; Height : integer;
                   U : PDouble; const LineWidthU : integer; W : PDouble; const LineWidthW : integer;
                   V : PDouble; const LineWidthV : integer; progress : TLinEquProgress = nil) : TSVDResult;

// Inplace Cholesky decomposition of the matrix A (A=L*L'). A must be a positive-definite symmetric matrix.
// The cholesky factor L is returned in the lower triangle of a, except for its diagonal elements which are returned in p
function MatrixCholeskyInPlace(A : PDouble; const LineWidthA : integer; width : integer; P : PDouble; LineWidthP : integer; progress : TLinEquProgress = nil) : TCholeskyResult;
function MatrixCholesky(dest : PDouble; const LineWidthDest : integer; A : PDouble; const LineWidthA : integer; width : integer;
  P : PDouble; const LineWidthP : integer; progress : TLinEquProgress = nil) : TCholeskyResult;
// solves the set of linear equations Ax = b where A is a positive-definite symmetric matrix. A and P are input as the output of
// MatrixCholeskyInPlace. Only the lower triangle is accessed. The result is stored in X, thus the routine can be called multiple
// times. B and X can point to the same memory!
procedure MatrixCholeskySolveLinEq(A : PDouble; const LineWidthA : integer; width : integer; P : PDouble;
  const LineWidthP : integer; B : PDouble; const LineWidthB : integer; X : PDouble; const LineWidthX : integer; progress : TLinEquProgress = nil);


// original functions from Numerical Recipies:
// In place QR decomposition. Constructs the QR decomposition of A (n*n). The upper triangle matrix R is returned
// in the upper triangle of a, except for the diagonal elements of R which are returned in
// d. The orthogonal matrix Q is represented as a product of n-1 Householder matrices Q1...Qn-1, where
// Qj = 1 - uj*(uj/cj). The ith component of uj is zero for i = 1..j-1 while the nonzero components are returned
// in a[i][j] for i = j...n . False is returned if no singularity was detected
function MatrixQRDecompInPlace(A : PDouble; const LineWidthA : integer; width : integer; C : PDouble; const LineWidthC : integer;
  D : PDouble; const LineWidthD : integer; progress : TLinEquProgress = nil) : TQRResult;
function MatrixQRDecomp(dest : PDouble; const LineWidthDest : integer; A : PDouble; const LineWidthA : integer; width : integer;
  C : PDouble; const LineWidthC : integer; D : PDouble; const LineWidthD : integer; progress : TLinEquProgress = nil) : TQRResult;
// solves the System A*x = b. The input paramaters are the output parameters from the QR decomposition.
// b is the matrix right hand side and will be overwritten by the result x.
procedure MatrixQRSolveLinEq(A : PDouble; const LineWidthA : integer; width : integer; C : PDouble; const LineWidthC : integer;
  D : PDouble; const LineWidthD : integer; B : PDouble; const LineWidthB : integer; progress : TLinEquProgress = nil);


// implementation of Lapack's blocked QR decomposition
// the upper triangle matrix R is returned in the upper triangle of A. The elements below the
// diagonal with the array TAU, represent the orthogonal matrix Q as a product of elementary reflectors.
// further details: The matrix Q is represented as a product of elementary reflectors
//   Q = H(1) H(2) . . . H(k), where k = min(m,n).
//   Each H(i) has the form
//   H(i) = I - tau * v * v**T
//   where tau is a real scalar, and v is a real vector with
//   v(1:i-1) = 0 and v(i) = 1; v(i+1:m) is stored on exit in A(i+1:m,i),
//   and tau in TAU(i).
// note the matrix above starts with index 1 instead of 0.
// the output is the same as the matlab economy size output on a QR decomposition e.g. dcmp = qr(A, 0);
function MatrixQRDecompInPlace2(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; progress : TLinEquProgress = nil) : TQRResult; overload;
function MatrixQRDecompInPlace2(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; work : PDouble; pnlSize : integer; progress : TLinEquProgress = nil) : TQRResult; overload;

// implementation of Lapacks dorgqr function: On start the matrix A and Tau contains the result of
// the MatrixQRDecompInPlace2 function (economy size QR Decomposition). On output A is replaced by the full Q
// matrix with orthonormal columns.
procedure MatrixQFromQRDecomp(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; progress : TLinEquProgress = nil); overload;
procedure MatrixQFromQRDecomp(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; BlockSize : integer; work : PDouble; progress : TLinEquProgress = nil); overload;

// Pseudoinversion - implementation taken from matlab
// X = pinv(A) produces a matrix X of the same dimensions
//  as A' so that A*X*A = A, X*A*X = X and A*X and X*A
//  are Hermitian. The computation is based on SVD(A) and any
//  singular values less than a tolerance are treated as zero.
//  The default tolerance is MAX(SIZE(A)) * NORM(A) * EPS(class(A))
// Note the Matrix in X is also used in the calculations, thus it's content is destroyed!
// dest must be at least as big as the transposed of X
function MatrixPseudoinverse(dest : PDouble; const LineWidthDest : integer; X : PDouble; const LineWidthX : integer;
  width, height : integer; progress : TLinEquProgress = nil) : TSVDResult;


// ######################################################
// #### internaly used objects and definitions
type
  TLinearEQProgress = class(TObject)
  public
    refProgress : TLinEquProgress;
    numRefinenmentSteps : integer;

    procedure LUDecompSolveProgress(Progress : Integer);
    procedure RefinementProgress(Progress : integer);
  end;


// only for internal use
type
  TRecMtxQRDecompData = record
    pWorkMem : PByte;
    work : PDouble;
    LineWidthWork : TASMNativeInt;
    BlkMultMem : PDouble;
    Progress : TLinEquProgress;
    qrWidth, qrHeight : integer;
    actIdx : integer;
    pnlSize : integer;

    MatrixMultT1 : TMatrixBlockedMultfunc;
    MatrixMultT2 : TMatrixBlockedMultfunc;
  end;

function InternalMatrixQRDecompInPlace2(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; qrData : TRecMtxQRDecompData) : boolean;
procedure InternalBlkMatrixQFromQRDecomp(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; qrData : TRecMtxQRDecompData);

implementation

uses Math, MathUtilFunc, ASMMatrixOperations,
     SimpleMatrixOperations, BlockSizeSetup;

function MatrixPseudoinverse(dest : PDouble; const LineWidthDest : integer; X : PDouble; const LineWidthX : integer;
  width, height : integer; progress : TLinEquProgress) : TSVDResult;
var doTranspose : boolean;
    data : TDoubleDynArray;
    UTranspose : TDoubleDynArray;
    pData : PDouble;
    lineWidthData : integer;
    S, V : TDoubleDynArray;
    lineWidthV : integer;
    tolerance : double;
    r : integer;
    i : integer;
    k, l : integer;
    pUTranspose : PDouble;
    res : TDoubleDynArray;
    pRes : PDouble;
    destOffset : integer;
begin
     // pseudo inversion of a matrix: pinv(x) = x'*(x*x')^-1
     // based on the matlab implementation:
     // [u s v] = svd(x, 0)
     // s = diag(S);
     // tol = max(m,n) * eps(max(s));
     // r = sum(s > tol);
     // s = diag(ones(r,1)./s(1:r));
     // X = V(:,1:r)*s*U(:,1:r)';
     assert((width > 0) and (height > 0) and (lineWidthDest >= height*sizeof(double)), 'Dimension error');


     doTranspose := width > height;
     if doTranspose then
     begin
          data := MatrixTranspose(X, LineWidthX, width, height);
          pData := @data[0];
          lineWidthData := height*sizeof(double);

          Result := MatrixPseudoinverse(X, LineWidthX, pData, lineWidthData, height, width);

          MatrixTranspose(dest, LineWidthDest, x, LineWidthX, width, height);
          exit;
     end;

     SetLength(S, width);
     SetLength(V, sqr(width));
     lineWidthV := width*sizeof(double);
     Result := MatrixSVDInPlace(X, lineWidthX, width, height, @S[0], sizeof(double), @V[0], lineWidthV, progress);

     if Result = srNoConvergence then
        exit;

     tolerance := height*eps(MatrixMax(@S[0], width, 1, width*sizeof(double)));

     r := 0;
     for i := 0 to width - 1 do
     begin
          if s[i] > tolerance then
             inc(r)
     end;

     if r = 0 then
     begin
          // set all to zero
          destOffset := LineWidthDest - height*sizeof(double);
          for k := 0 to width - 1 do
          begin
               for l := 0 to height - 1 do
               begin
                    dest^ := 0;
                    inc(dest);
               end;

               inc(PByte(dest), destOffset);
          end;
     end
     else
     begin
          // invert
          for i := 0 to width - 1 do
          begin
               if s[i] > tolerance
               then
                   s[i] := 1/s[i]
               else
                   s[i] := 0;
          end;

          UTranspose := MatrixTranspose(X, LineWidthX, width, height);
          pUTranspose := @UTranspose[0];
          for k := 0 to width - 1 do
          begin
               for l := 0 to height - 1 do
               begin
                    pUTranspose^ := pUTranspose^*s[k];
                    inc(pUTranspose);
               end;
          end;

          res := MatrixMult(@V[0], @UTranspose[0], width, width, height, width, width*sizeof(double), height*sizeof(double));
          V := nil;
          UTranspose := nil;
          s := nil;

          // copy
          pRes := @res[0];
          for k := 0 to width - 1 do
          begin
               Move(pRes^, dest^, sizeof(double)*height);
               inc(PByte(dest), LineWidthDest);
               inc(PByte(pRes), sizeof(double)*height);
          end;
     end;
end;

function MatrixGaussJordan(A : PDouble; const LineWidthA : integer; B : PDouble; const LineWidthB : integer;
                           invA : PDouble; const LineWidthInvA : integer; X : PDouble; const LineWidthX : integer;
                           width : integer; m : integer; const epsilon : double; progress : TLinEquProgress) : TLinEquResult;
var i: Integer;
    pInvA : PDouble;
    PX : PDouble;
begin
     Assert(width > 0, 'Dimension Error');
     Assert(lineWidthInvA >= width*sizeof(double), 'Dimension error');
     Assert(lineWidthX >= sizeof(double), 'Dimension error');

     // copy data -> now we can perform an inline gauss elimination procedure
     PInvA := invA;
     PX := X;
     for i := 0 to width - 1 do
     begin
          Move(A^, PInvA^, sizeof(double)*width);
          inc(PByte(PInvA), LineWidthInvA);
          inc(PByte(A), LineWidthA);
          Move(B^, PX^, sizeof(double)*m);
          inc(PByte(B), LineWidthB);
          inc(PByte(PX), LineWidthX);
     end;

     Result := MatrixGaussJordaninPlace(invA, lineWidthInvA, X, LineWidthX, width, m, epsilon, progress);
end;

function MatrixGaussJordanInPlace(A : PDouble; const LineWidthA : integer; B : PDouble; const LineWidthB : integer;
  width : integer; m : integer; const epsilon : double; progress : TLinEquProgress) : TLinEquResult;
var i, icol, irow, j, k, l, ll : integer;
    big, dum, pivinv : double;
    indxc, indxr, ipiv : Array of integer;
    pVal1 : PDouble;
    pVal2 : PDouble;
begin
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');
     assert(LineWidthB >= m*sizeof(double), 'Dimension error');

     Result := leOk;

     SetLength(indxc, width);
     SetLength(indxr, width);
     SetLength(ipiv, width);

     icol := 0;
     irow := 0;

     if Assigned(progress) then
        progress(0);

     for j := 0 to width - 1 do
         ipiv[j] := 0;

     // main loop over the columns to be reduced
     for i := 0 to width - 1 do
     begin
          big := 0;
          for j := 0 to width - 1 do
          begin
               if ipiv[j] <> 1 then
               begin
                    for k := 0 to width - 1 do
                    begin
                         if ipiv[k] = 0 then
                         begin
                              pVal1 := PDouble(PAnsiChar(A) + j*LineWidthA);
                              inc(pVal1, k);

                              if abs(pVal1^) >= big then
                              begin
                                   big := abs(pVal1^);
                                   irow := j;
                                   icol := k;
                              end;
                         end
                         else if ipiv[k] > 1 then
                         begin
                              Result := leSingular;
                              exit;
                         end;
                    end;
               end;
          end;

          inc(ipiv[icol]);

          // we now have the pivot element, so we interchange rows, if needed, to put the pivot
          // element on the dagonal.

          if irow <> icol then
          begin
               pVal1 := PDouble(PAnsiChar(A) + irow*LineWidthA);
               pVal2 := PDouble(PAnsiChar(A) + icol*LineWidthA);
               for l := 0 to width - 1 do
               begin
                    DoubleSwap(pVal1^, pVal2^);
                    inc(pVal1);
                    inc(pVal2);
               end;

               pVal1 := PDouble(PAnsiChar(B) + irow*LineWidthB);
               pVal2 := PDouble(PAnsiChar(B) + icol*LineWidthB);
               for l := 0 to m - 1 do
               begin
                    DoubleSwap(pVal1^, pVal2^);
                    inc(pVal1);
                    inc(pVal2);
               end;
          end;

          // we are now ready to divide the pivot row by the pivot element, located in irow and icol
          indxr[i] := irow;
          indxc[i] := icol;

          pVal1 := PDouble(PAnsiChar(A) + icol*LineWidthA);
          inc(pVal1, icol);

          if abs(pVal1^) < epsilon then
          begin
               Result := leSingular;
               exit;
          end;

          pivinv := 1/pVal1^;

          pVal1^ := 1;
          pVal1 := PDouble(PAnsiChar(A) + icol*LineWidthA);
          for l := 0 to width - 1 do
          begin
               pVal1^ := pVal1^*pivinv;
               inc(pVal1);
          end;

          pVal1 := PDouble(PAnsiChar(B) + icol*LineWidthB);
          for l := 0 to m - 1 do
          begin
               pVal1^ := Pivinv*pVal1^;
               inc(pVal1);
          end;

          for ll := 0 to width - 1 do
          begin
               if ll <> icol then
               begin
                    pVal1 := PDouble(PAnsiChar(A) + ll*LineWidthA);
                    inc(pVal1, icol);
                    dum := pVal1^;
                    pVal1^ := 0;

                    pVal1 := PDouble(PAnsiChar(A) + ll*LineWidthA);
                    pVal2 := PDouble(PAnsiChar(A) + icol*LineWidthA);
                    for l := 0 to width - 1 do
                    begin
                         pVal1^ := pVal1^ - pVal2^*dum;
                         inc(pVal1);
                         inc(pVal2);
                    end;

                    pVal1 := PDouble(PAnsiChar(B) + ll*LineWidthB);
                    pVal2 := PDouble(PAnsiChar(B) + icol*LineWidthB);
                    for l := 0 to m - 1 do
                    begin
                         pVal1^ := pVal1^ - pVal2^*dum;
                         inc(pVal1);
                         inc(pVal2);
                    end;
               end;
          end;

          if Assigned(progress) then
             progress(100*i div width);
     end;

     for l := width - 1 downto 0 do
     begin
          if indxr[l] <> indxc[l] then
          begin
               for k := 0 to width - 1 do
               begin
                    pVal1 := PDouble(PAnsiChar(A) + k*LineWidthA);
                    pVal2 := pVal1;
                    inc(pval1, indxr[l]);
                    inc(pval2, indxc[l]);

                    DoubleSwap(pVal1^, pVal2^);
               end;
          end;
     end;

     if Assigned(progress) then
        progress(100);
end;

// LUSWAP performs a series of row interchanges on the matrix A.
// One row interchange is initiated for each of rows K1 through K2 of A.
procedure LUSwap(A : PDouble; const LineWidthA : Integer; width : integer; k1, k2 : integer; indx : PIntegerArray; var parity : integer);
var i : integer;
    pA1, pA2 : PDouble;
begin
     for i := k1 to k2 do
     begin
          if indx^[i] <> i then
          begin
               // interchange rows
               pA1 := A;
               inc(PByte(pA1), i*LineWidthA);
               pA2 := A;
               inc(PByte(pA2), indx^[i]*LineWidthA);

               // swap a complete row at once
               MatrixRowSwap(pA1, pA2, width);

               parity := -parity;
          end;
     end;
end;

procedure LUBacksup(A : PDouble; width, height : integer; B : PDouble; const LineWidth : integer);
var j, i, k : integer;
    pA, pAi : PDouble;
    pB, pBj : PDouble;
    pBDest, pBDestj, pBDesti : PDouble;
begin
     pA := A;
     inc(PByte(pA), LineWidth);

     pB := B;
     pBDest := B;
     inc(PByte(pBDest), LineWidth);
     for k := 0 to height - 1 do
     begin
          pAi := pA;
          pBDesti := pBDest;

          for i := k + 1 to height - 1 do
          begin
               pBj := pB;
               pBDestj := pBDesti;
               for j := 0 to width - 1 do
               begin
                    pBDestj^ := pBDestj^ - pBj^*pAi^;

                    inc(pBj);
                    inc(pBDestj);
               end;

               inc(PByte(pAi), LineWidth);
               inc(PByte(pBDesti), LineWidth);
          end;
          inc(pA);
          inc(PByte(pA), LineWidth);
          inc(PByte(pB), LineWidth);
          inc(PByte(pBDest), LineWidth);
     end;
end;

const cBlkMultSize = 48;
type
  TRecMtxLUDecompData = record
    progress : TLinEquProgress;
    numCols,
    numCalc : integer;
    blkMultMem : Pdouble;
    LineWidth : TASMNativeInt;
  end;

function InternalRecursiveMatrixLUDecompInPlace(A : PDouble;  width, height : integer;
 indx : PIntegerArray; var parity : integer; var data : TRecMtxLUDecompData) : TLinEquResult;
var mn : integer;
    pA : PDouble;
    idx : integer;
    maxVal : double;
    nleft, nright : integer;
    i : integer;
    pB, a12, a21 : PDouble;
    absMaxVal : double;
begin
     mn := min(width, height);

     if mn > 1 then
     begin
          nleft := mn div 2;
          nright := width - nleft;

          Result := InternalRecursiveMatrixLUDecompInPlace(A, nLeft, height, indx, parity, data);

          if Result <> leOk then
             exit;

          pA := A;
          inc(pA, nLeft);
          LUSwap(pA, data.LineWidth, nright, 0, nleft - 1, indx, parity);

          // lu backsup A12 = L - one*A12
          if nRight > 1 then
             LUBacksup(A, nRight, nLeft, pA, data.LineWidth);

          // matrix mult sub
          // A22 = A22 - A21*A12
          pB := A;
          inc(pB, nleft);
          a12 := pB;
          inc(PByte(pB), nLeft*data.LineWidth);

          a21 := A;
          inc(PByte(a21), nleft*data.LineWidth);
          // in this case it's faster to have a small block size!
          if (nright > cBlkMultSize) or (height - nleft > cBlkMultSize)
          then
              BlockedMatrixMultiplication(pB, data.LineWidth, a21, a12, nleft, height - nleft, nright, nleft, data.LineWidth, data.LineWidth, cBlkMultSize, doSub, data.blkMultMem)
          else
          begin
               MatrixMult(data.blkMultMem, (nright + nright and $01)*sizeof(double), a21, a12, nleft, height - nleft, nright, nleft, data.LineWidth, data.LineWidth);
               MatrixSub(pB, data.LineWidth, pB, data.blkMultMem, nright, height - nleft, data.LineWidth, (nright + nright and $01)*sizeof(double));
          end;

          // apply recursive LU to A(nleft + 1, nleft + 1);
          Result := InternalRecursiveMatrixLUDecompInPlace(pB, nright, height - nleft, @(indx^[nleft]), parity, data);
          if Result <> leok then
             exit;

          for i := nLeft to width - 1 do
              indx^[i] := indx^[i] + nLeft;

          // dlswap
          LUSwap(A, data.LineWidth, nleft, nleft, mn - 1, indx, parity);
     end
     else
     begin
          // find maximum element of this column
          maxVal := 0;
          absMaxVal := 0;
          idx := -1;
          pA := A;
          for i := 0 to Height - 1 do
          begin
               if Abs(pA^) > absMaxVal then
               begin
                    idx := i;
                    maxVal := pA^;
                    absMaxVal := abs(maxVal);
               end;

               inc(PByte(pA), data.LineWidth);
          end;

          // now it's time to apply the gauss elimination
          indx^[0] := idx;

          // check for save invertion of maxVal
          if Abs(maxVal) > 10/MaxDouble then
          begin
               MatrixScaleAndAdd(A, data.LineWidth, 1, Height, 0, 1/maxVal);
               pA := A;
               inc(PByte(pA), data.LineWidth*idx);
               pA^ := A^;
               A^ := maxVal;

               Result := leOk;

               if Assigned(data.progress) then
               begin
                    inc(data.numCalc);
                    data.progress(data.numCalc*100 div data.numCols);
               end;
          end
          else
              Result := leSingular;
     end;
end;

function MatrixLUDecompInPlace(A : PDouble; const LineWidthA : Integer; width : integer; indx : PIntegerArray; progress : TLinEquProgress) : TLinEquResult;
var parity : integer;
    mem : Array[0..(4+4*cBlkMultSize*cBlkMultSize)] of double;
    rc : TRecMtxLUDecompData;
begin
     FillChar(indx^, width*sizeof(integer), 0);
     parity := 1;
     rc.progress := progress;
     rc.numCols := width;
     rc.numCalc := 0;
     rc.blkMultMem := PDouble(TASMNativeUInt(@mem[0]) + 16 - (TASMNativeUInt(@mem[0]) and $0F));
     rc.LineWidth := LineWidthA;
     Result := InternalRecursiveMatrixLUDecompInPlace(A, width, width, indx, parity, rc);
end;

function MatrixLUDecomp(A : PDouble; const LineWidthA : integer; LUDecomp : PDouble; const LineWidthLU : integer; width : integer; indx : PIntegerArray; progress : TLinEquProgress) : TLinEquResult;
begin
     Assert(width > 0, 'Dimension Error');

     // copy data -> now we can perform an inline LU decomposition
     MatrixCopy(LUDecomp, LineWidthLU, A, LineWidthA, width, width);
     Result := MatrixLUDecompInPlace(LUDecomp, lineWidthLU, width, indx, progress);
end;

function MatrixLUDecomp(A : PDouble; const LineWidthA : integer; LUDecomp : PDouble; const LineWidthLU : integer; width : integer; progress : TLinEquProgress) : TLinEquResult;
var indx : array of integer;
begin
     Assert(width > 0, 'Dimension Error');
     setLength(indx, width);

     Result := MatrixLUDecomp(A, LineWidthA, LUDecomp, LineWidthLU, width, @indx[0], progress);
end;

procedure MatrixLUBackSubst(LUDecomp : PDouble; const LineWidthLU : integer; width : integer; const  indx : PIntegerArray;
  B : PDouble; const LineWidthB : integer; progress : TLinEquProgress);
var i : Integer;
    ii : integer;
    ip : integer;
    j : integer;
    sum : double;
    pB : PDouble;
    pB2 : PDouble;
    pVal : PDouble;
    pVal2 : PDouble;
begin
     assert(width*sizeof(double) <= LineWidthLU, 'Dimension Error');

     if Assigned(progress) then
        progress(0);

     ii := -1;
     pB2 := B;
     for i := 0 to width - 1 do
     begin
          ip := indx^[i];
          pB := B;
          inc(PByte(pB), ip*LineWidthB);
          sum := pB^;
          pB^ := pB2^;

          if ii >= 0 then
          begin
               pVal := PDouble(PAnsiChar(LUDecomp) + i*LineWidthLU);
               inc(pVal, ii);
               pB := B;
               inc(PByte(pB), LineWidthB*ii);
               for j := ii to i - 1 do
               begin
                    sum := sum - pVal^*pB^;
                    inc(pVal);
                    inc(PByte(pB), LineWidthB);
               end;
          end
          else if sum <> 0
          then
              ii := i;

          pB2^ := sum;
          inc(PByte(pB2), LineWidthB);
     end;

     if Assigned(progress) then
        progress(50);

     pB := B;
     inc(PByte(pB), LineWidthB*(width - 1));
     pVal := PDouble(PAnsiChar(LUDecomp) + (width - 1)*LineWidthLU);
     inc(pVal, width - 1);
     for i := width - 1 downto 0 do
     begin
          sum := pB^;

          pB2 := pB;
          inc(PByte(pB2), LineWidthB);
          pVal2 := pVal;
          inc(pVal2);
          for j := i + 1 to width - 1 do
          begin
               sum := sum - pVal2^*pB2^;
               inc(PByte(pB2), LineWidthB);
               inc(pVal2);
          end;

          pB^ := sum/pVal^;

          dec(pVal);
          dec(PByte(pVal), LineWidthLU);
          dec(PByte(pB), LineWidthB);
     end;

     if Assigned(progress) then
        progress(100);
end;

function MatrixInverseInPlace(A : PDouble; const LineWidthA : integer; width : integer; progress : TLinEquProgress) : TLinEquResult;
var Y : PDouble;
    indx : array of integer;
    i, j : Integer;
    pVal : PDouble;
    col : TDoubleDynArray;
    w : integer;
begin
     Assert(lineWidthA >= width*sizeof(double), 'Dimension Error');
     Assert(width > 0, 'Dimension error');

     w := width + width and $01;
     Y := GetMemory(w*w*sizeof(double));
     SetLength(indx, width);
     SetLength(col, width);

     MatrixCopy(Y, sizeof(double)*w, A, LineWidthA, width, width);
     Result := MatrixLUDecompInPlace(Y, w*sizeof(double), width, @indx[0], progress);

     if Result = leSingular then
     begin
          FreeMem(Y);
          exit;
     end;

     for j := 0 to width - 1 do
     begin
          pVal := A;
          inc(pVal, j);

          for i := 0 to width - 1 do
              col[i] := 0;
          col[j] := 1;
          MatrixLUBackSubst(Y, w*sizeof(double), width, @indx[0], @col[0], sizeof(double));

          for i := 0 to width - 1 do
          begin
               pVal^ := col[i];
               inc(PByte(pVal), LineWidthA);
          end;
     end;

     FreeMem(Y);
end;

function MatrixDeterminant(A : PDouble; const LineWidthA : integer; width : integer; progress : TLinEquProgress) : double;
var LUDecomp : PDouble;
    indx : Array of Integer;
    i : integer;
    pVal : PDouble;
    parity : integer;
    rc : TRecMtxLUDecompData;
    w : integer;
    mem : Array[0..(4+4*cBlkMultSize*cBlkMultSize)] of double;
begin
     assert(width > 0, 'Dimension error');
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');

     w := width + width and $01;
     LUDecomp := GetMemory(w*w*sizeof(double));
     SetLength(indx, width);
     MatrixCopy(LUDecomp, w*sizeof(double), A, LineWidthA, width, width);

     rc.progress := progress;
     rc.numCols := width;
     rc.numCalc := 0;
     rc.blkMultMem := PDouble(TASMNativeUInt(@mem[0]) + 16 - TASMNativeUInt(@mem[0]) and $0F);
     rc.LineWidth := w*sizeof(double);

     parity := 1;
     if InternalRecursiveMatrixLUDecompInPlace(LUDecomp, width, width, @indx[0], parity, rc) = leSingular then
     begin
          Result := 0;
          FreeMem(LUDecomp);
          exit;
     end;
     pVal := LUDecomp;
     Result := parity;
     for i := 0 to width - 1 do
     begin
          Result := Result * pVal^;
          inc(pVal);
          inc(PByte(pVal), w*sizeof(double));
     end;

     FreeMem(LUDecomp);
end;

{ TLinearEQProgress }

procedure TLinearEQProgress.LUDecompSolveProgress(Progress: Integer);
begin
     if numRefinenmentSteps > 0 
     then
         refProgress(progress*8 div 10)
     else
         refProgress(progress);
end;

procedure TLinearEQProgress.RefinementProgress(Progress: integer);
begin
     refProgress(80 + 2*progress div 10);
end;

function MatrixLinEQSolve(A : PDouble; const LineWidthA : integer; width : integer; B : PDouble; const LineWidthB : integer; X : PDouble;
 const LineWidthX : integer;  Width2 : integer; const NumRefinments : integer; progress : TLinEquProgress) : TLinEquResult;
var indx : Array of Integer;
    LUDecomp : TDoubleDynArray;
    sdp : double;
    row : TDoubleDynArray;
    pB : PDouble;
    i : Integer;
    pA : PDouble;
    j, k : Integer;
    pX : PDouble;
    pVal : PDouble;
    refinementCounter : integer;
    progObj : TLinearEQProgress;
    progRef : TLinEquProgress;
begin
     progRef := nil;
     progObj := nil;
     if Assigned(progress) then
     begin
          progObj := TLinearEQProgress.Create;
          progObj.refProgress := progress;
          progObj.numRefinenmentSteps := NumRefinments;
          progRef := {$IFDEF FPC}@{$ENDIF}progObj.LUDecompSolveProgress;
     end;


     // ###########################################
     // #### Standard LU Decomposition
     SetLength(LUDecomp, width*width);
     SetLength(indx, width);
     Result := MatrixLUDecomp(A, LineWidthA, @LUDecomp[0], width*sizeof(double), width, @indx[0], progRef);

     if Result = leSingular then
     begin
          progObj.Free;
          exit;
     end;

     for i := 0 to width2 - 1 do
     begin
          // copy one column
          pX := X;
          inc(pX, i);
          pVal := B;
          inc(pVal, i);
          for j := 0 to width - 1 do
          begin
               pX^ := pVal^;
               inc(PByte(pX), LineWidthX);
               inc(PByte(pVal), LineWidthB);
          end;
          pX := X;
          inc(pX, i);

          // calculate vector X
          MatrixLUBackSubst(@LUDecomp[0], width*sizeof(double), width, @indx[0], pX, LineWidthX);
     end;

     // ###########################################
     // #### Iterative refinements
     if NumRefinments > 0 then
     begin
          SetLength(row, width);
          // for each solution do a separate refinement:
          for k := 0 to width2 - 1 do
          begin
               if Assigned(progobj) then
                  progObj.RefinementProgress(Int64(k)*100 div Int64(width2));

               for refinementCounter := 0 to NumRefinments - 1 do
               begin
                    pb := B;

                    pA := A;
                    for i := 0 to width - 1 do
                    begin
                         pVal := pA;

                         sdp := -pB^;
                         inc(PByte(pB), LineWidthB);
                         pX := X;
                         for j := 0 to width - 1 do
                         begin
                              sdp := sdp + pX^*pVal^;
                              inc(pVal);
                              inc(pX);
                         end;

                         inc(PByte(pA), LineWidthA);
                         row[i] := sdp;
                    end;

                    MatrixLUBackSubst(@LUDecomp[0], sizeof(double)*width, width, @indx[0], @row[0], sizeof(double));
                    pX := X;
                    for i := 0 to width - 1 do
                    begin
                         pX^ := pX^ - row[i];
                         inc(PByte(pX), LineWidthX);
                    end;
               end;

               inc(B);
               inc(X);
          end;
     end;

     if Assigned(progObj) then
        progObj.Free;
     if Assigned(progress) then
        progress(100);
end;

function MatrixSVDInPlace(A : PDouble; const LineWidthA : integer; width : integer; Height : integer; W : PDouble; const LineWidthW : integer;
  V : PDouble; const LineWidthV : integer; progress : TLinEquProgress) : TSVDResult;
const cMaxNumSVDIter = 75;
var flag : boolean;
    i, j, jj, k, l : integer;
    its : integer;
    nm : integer;
    anorm : double;
    c, f, g, h : double;
    s, scale, x, y, z : double;
    rv1 : Array of double;
    pA : PDouble;
    pAi : PDouble;
    pAj : PDouble;
    pV : PDouble;
    pVj : PDouble;
    invScale : double;
    invh : double;
    val : double;
    pWi : PDouble;
begin
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');
     assert(LineWidthV >= width*sizeof(double), 'Dimension error');

     if Assigned(progress) then
        progress(0);

     SetLength(rv1, width);

     g := 0;
     scale := 0;
     anorm := 0;
     l := 1;
     nm := 0;

     Result := srNoConvergence;

     pWi := W;
     // Householder reduction to bidiagonal form
     pAi := A;
     for i := 0 to width - 1 do
     begin
          if Assigned(progress) then
             progress(0 + Round(10*(i/width)));

          l := i + 1;

          rv1[i] := scale*g;
          g := 0;
          s := 0;
          scale := 0;

          if i < height then
          begin
               pA := pAi;
               inc(pA, i);

               for k := i to height - 1 do
               begin
                    scale := scale + abs(pA^);

                    inc(PByte(pA), LineWidthA);
               end;

               if scale <> 0 then
               begin
                    pA := pAi;
                    inc(pA, i);
                    invScale := 1/scale;

                    for k := i to height - 1 do
                    begin
                         pA^ := pA^*invScale;
                         s := s + sqr(pA^);

                         inc(PByte(pA), LineWidthA);
                    end;

                    pA := pAi;
                    inc(pA, i);
                    f := pA^;

                    g := -sign(sqrt(s), f);
                    h := f*g - s;
                    pA^ := f - g;
                    invh := 1/h;

                    for j := l to width - 1 do
                    begin
                         s := 0;
                         pA := pAi;
                         pAj := pA;
                         inc(pA, i);
                         inc(pAj, j);

                         for k := i to height - 1 do
                         begin
                              s := s + pA^*pAj^;
                              inc(PByte(pA), LineWidthA);
                              inc(PByte(pAj), LineWidthA);
                         end;
                         f := s*invh;

                         pA := pAi;
                         pAj := pA;
                         inc(pA, i);
                         inc(pAj, j);
                         for k := i to height - 1 do
                         begin
                              pAj^ := pAj^ + f*pA^;
                              inc(PByte(pAj), LineWidthA);
                              inc(PByte(pA), LineWidthA);
                         end;
                    end;

                    pA := pAi;
                    inc(pA, i);
                    for k := i to height - 1 do
                    begin
                         pA^ := scale*pA^;
                         inc(PByte(pA), LineWidthA);
                    end;
               end; // end if scale
          end; // end if i < height

          pWi^ := scale*g;

          g := 0;
          scale := 0;
          s := 0;

          if (i < width) and (i <> width - 1) then
          begin
               pA := pAi;
               inc(pA, l);

               for k := l to width - 1 do
               begin
                    scale := scale + abs(pA^);

                    inc(pA);
               end;

               if scale <> 0 then
               begin
                    pA := pAi;
                    inc(pA, l);
                    invScale := 1/scale;

                    for k := l to width - 1 do
                    begin
                         pA^ := pA^*invScale;
                         s := s + sqr(pA^);

                         inc(pA);
                    end;

                    pA := pAi;
                    inc(pA, l);
                    f := pA^;

                    g := -sign(sqrt(s), f);
                    h := f*g - s;
                    pA^ := f - g;
                    invh := 1/h;

                    for k := l to width - 1 do
                    begin
                         rv1[k] := pA^*invh;
                         inc(pA);
                    end;

                    for j := l to height - 1 do
                    begin
                         s := 0;
                         pAj := A;
                         inc(pAj, l);
                         pA := pAi;
                         inc(pA, l);
                         inc(PByte(pAj), LineWidthA*j);

                         for k := l to width - 1 do
                         begin
                              s := s + pAj^*pA^;
                              inc(pAj);
                              inc(pA);
                         end;

                         pA := A;
                         inc(PByte(pA), LineWidthA*j);
                         inc(pA, l);
                         for k := l to width - 1 do
                         begin
                              pA^ := pA^ + s*rv1[k];
                              inc(pA);
                         end;
                    end;

                    pA := pAi;
                    inc(pA, l);

                    for k := l to width - 1 do
                    begin
                         pA^ := pA^*scale;
                         inc(pA);
                    end;
               end;
          end;

          anorm := max(anorm, abs(pWi^) + abs(rv1[i]));

          inc(PByte(pWi), LineWidthW);
          inc(PByte(pAi), LineWidthA);
     end;

     // accumulation of right-hand transformations
     pAi := A;
     inc(PByte(pAi), (width - 1)*LineWidthA);
     for i := width - 1 downto 0 do
     begin
          if Assigned(progress) then
             progress(Round(10 + 10*((width - 1 - i)/(width))));

          if i < width - 1 then
          begin
               if g <> 0 then
               begin
                    pV := V;
                    inc(pV, i);
                    inc(PByte(pV), LineWidthV*l);
                    pA := pAi;
                    inc(pA, l);
                    val := pA^;
                    val := 1/(val*g);

                    for j := l to width - 1 do
                    begin
                         pV^ := pA^*val;
                         inc(pA);
                         inc(PByte(pV), LineWidthV);
                    end;

                    for j := l to width - 1 do
                    begin
                         s := 0;

                         pA := pAi;
                         inc(pA, l);
                         pV := V;
                         inc(pV, j);
                         inc(PByte(pV), LineWidthV*l);

                         for k := l to width - 1 do
                         begin
                              s := s + pA^*pV^;
                              inc(pA);
                              inc(PByte(pV), LineWidthV);
                         end;

                         pV := V;
                         inc(pV, i);
                         inc(PByte(pV), LineWidthV*l);
                         pVj := V;
                         inc(pVj, j);
                         inc(PByte(pVj), LineWidthV*l);

                         for k := l to width - 1 do
                         begin
                              pVj^ := pVj^ + s*pV^;
                              inc(PByte(pVj), LineWidthV);
                              inc(PByte(pV), LineWidthV);
                         end;
                    end;
               end;  // end if g <> 0

               pV := V;
               inc(pV, l);
               inc(PByte(pV), LineWidthV*i);
               pVj := V;
               inc(pVj, i);
               inc(PByte(pVj), LineWidthV*l);

               for j := l to width - 1 do
               begin
                    pV^ := 0;
                    pVj^ := 0;
                    inc(pV);
                    inc(PByte(pVj), LineWidthV);
               end;
          end; // end if i < width -1
          pV := V;
          inc(pV, i);
          inc(PByte(pV), LineWidthV*i);

          pV^ := 1;
          g := rv1[i];
          l := i;

          dec(PByte(pAi), LineWidthA);
     end;

     pWi := W;
     inc(PByte(pWi), (min(width, height) - 1)*LineWidthW);
     pAi := A;
     inc(PByte(pAi), (min(width, height) - 1)*LineWidthA);
     // accumulation of left-hand transformations
     for i := min(width, height) - 1 downto 0 do
     begin
          if Assigned(progress) then
             progress(Round(20 + 10*((Min(width, height) - 1 - i)/(Min(width, height)))));

          l := i + 1;
          g := pWi^;

          pA := pAi;
          inc(pA, l);
          for j := l to width - 1 do
          begin
               pA^ := 0;
               inc(pA);
          end;

          if g <> 0 then
          begin
               g := 1/g;

               for j := l to width - 1 do
               begin
                    s := 0;
                    pA := A;
                    inc(pA, i);
                    inc(PByte(pA), l*LineWidthA);
                    pAj := A;
                    inc(pAj, j);
                    inc(PByte(pAj), l*LineWidthA);

                    for k := l to height - 1 do
                    begin
                         s := s + pA^*pAj^;
                         inc(PByte(pA), LineWidthA);
                         inc(PByte(pAj), LineWidthA);
                    end;

                    pA := pAi;
                    inc(pA, i);
                    f := (s/pA^)*g;
                    pAj := pAi;
                    inc(pAj, j);
                    for k := i to height - 1 do
                    begin
                         pAj^ := pAj^ + f*pA^;
                         inc(PByte(pAj), LineWidthA);
                         inc(PByte(pA), LineWidthA);
                    end;
               end;

               pA := pAi;
               inc(pA, i);
               for j := i to height - 1 do
               begin
                    pA^ := pA^*g;
                    inc(PByte(pA), LineWidthA);
               end;
          end
          else
          begin
               pA := pAi;
               inc(pA, i);
               for j := i to height - 1 do
               begin
                    pA^ := 0;
                    inc(PByte(pA), LineWidthA);
               end;
          end;
          pA := pAi;
          inc(pA, i);
          pA^ := pA^ + 1;

          dec(PByte(pWi), LineWidthW);
          dec(PByte(pAi), LineWidthA);
     end;

     // Diagonalization of the bidiagonal form: loop over singular values and over
     // allowed iterations
     for k := width - 1 downto 0 do
     begin
          if Assigned(progress) then
             progress(Round(30 + 70*((Min(width, height) - 1 - k)/(Min(width, height)))));

          for its := 0 to cMaxNumSVDIter - 1 do
          begin
               flag := true;
               // test for splitting
               for l := k downto 0 do
               begin
                    nm := l - 1;
                    if abs(rv1[l]) + anorm = anorm then
                    begin
                         flag := False;
                         break;
                    end;

                    if abs(PDouble(PAnsiChar(W) + nm*LineWidthW)^) + anorm = anorm then
                       break;
               end;

               // Cancellation of rv1[o] if l > 1
               if flag then
               begin
                    c := 0;
                    s := 1;
                    for i := l to k do
                    begin
                         f := s*rv1[i];
                         rv1[i] := c*rv1[i];
                         if abs(f) + anorm <> anorm then    // check if the value is lower than the precission in contrast to anorm
                         begin
                              g := PDouble(PAnsiChar(W) + i*LineWidthW)^;
                              h := pythag(f, g);
                              PDouble(PAnsiChar(W) + i*LineWidthW)^ := h;
                              h := 1/h;
                              c := g*h;
                              s := -f*h;
                              pA := A;
                              inc(pA, nm);
                              pAj := A;
                              inc(pAj, i);

                              for j := 0 to height - 1 do
                              begin
                                   y := pA^;
                                   z := pAj^;
                                   pA^ := y*c + z*s;
                                   pAj^ := z*c - y*s;

                                   inc(PByte(pA), LineWidthA);
                                   inc(PByte(pAj), LineWidthA);
                              end;
                         end;
                    end;
               end;

               z := PDouble(PAnsiChar(W) + k*LineWidthW)^;
               // convergence
               if l = k then
               begin
                    if z < 0 then
                    begin
                         PDouble(PAnsiChar(W) + k*LineWidthW)^ := -z;

                         pV := V;
                         inc(pV, k);

                         for j := 0 to width - 1 do
                         begin
                              pV^ := -pV^;
                              inc(PByte(pV), LineWidthV);
                         end;
                    end;

                    break;
               end;

               if its = cMaxNumSVDIter - 1 then
                  exit;

               x := PDouble(PAnsiChar(W) + l*LineWidthW)^;
               nm := k - 1;
               y := PDouble(PAnsiChar(W) + nm*LineWidthW)^;
               g := rv1[nm];
               h := rv1[k];
               f := ((y - z)*(y + z) + (g - h)*(g + h))/(2*h*y);
               g := pythag(f, 1);
               val := g;
               if f < 0 then
                  val := -val;
               f := ((x - z)*(x + z) + h*((y/(f + val)) - h))/x;
               c := 1;
               s := 1;

               // next QR transformation
               for j := l to nm do
               begin
                    i := j + 1;
                    g := rv1[i];
                    y := PDouble(PAnsiChar(W) + i*LineWidthW)^;
                    h := s*g;
                    g := c*g;
                    z := pythag(f, h);
                    rv1[j] := z;
                    c := f/z;
                    s := h/z;
                    f := x*c + g*s;
                    g := g*c - x*s;
                    h := y*s;
                    y := y*c;

                    pVj := V;
                    inc(pVj, j);
                    pV := V;
                    inc(pV, i);
                    for jj := 0 to width - 1 do
                    begin
                         x := pVj^;
                         z := pV^;
                         pVj^ := x*c + z*s;
                         pV^ := z*c - x*s;

                         inc(PByte(pV), LineWidthV);
                         inc(PByte(pVj), LineWidthV);
                    end;

                    z := pythag(f, h);
                    PDouble(PAnsiChar(W) + j*LineWidthW)^ := z;
                    // rotation can be arbitrary if z = 0
                    if z <> 0 then
                    begin
                         z := 1/z;
                         c := f*z;
                         s := h*z;
                    end;

                    f := c*g + s*y;
                    x := c*y - s*g;

                    pA := A;
                    inc(pA, i);
                    pAj := A;
                    inc(pAj, j);
                    for jj := 0 to height - 1 do
                    begin
                         y := pAj^;
                         z := pA^;
                         pAj^ := y*c + z*s;
                         pA^ := z*c - y*s;
                         inc(PByte(pAj), LineWidthA);
                         inc(PByte(pA), LineWidthA);
                    end;
               end;

               rv1[l] := 0;
               rv1[k] := f;
               PDouble(PAnsiChar(W) + k*LineWidthW)^ := x;
          end;
     end;

     Result := srOk;
end;

function MatrixSVD(A : PDouble; const LineWidthA : integer; width : integer; Height : integer;
                   U : PDouble; const LineWidthU : integer; W : PDouble; const LineWidthW : integer;
                   V : PDouble; const LineWidthV : integer; progress : TLinEquProgress) : TSVDResult;
begin
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');
     assert(LineWidthV >= width*sizeof(double), 'Dimension error');

     MatrixCopy(U, LineWidthU, A, LineWidthA, width, Height);
     Result := MatrixSVDInPlace(U, LineWidthU, width, Height, W, LineWidthW, V, LineWidthV, progress);
end;

function MatrixCholeskyInPlace(A : PDouble; const LineWidthA : integer; width : integer; P : PDouble;
  LineWidthP : integer; progress : TLinEquProgress) : TCholeskyResult;
var i, j, k : integer;
    sum : double;
    pA : PDouble;
    pA1 : PDouble;
    pAj : PDouble;
    pAj1 : PDouble;
begin
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');

     if Assigned(progress) then
        progress(0);

     Result := crNoPositiveDefinite;
     pA := A;

     for i := 0 to width - 1 do
     begin
          if Assigned(progress) then
             progress(int64(i)*100 div width);

          pAj := pA;
          
          for j := i to width - 1 do
          begin
               sum := PDouble(PAnsiChar(pA) + j*sizeof(double))^;

               pAj1 := pAj;
               pA1 := pA;
               if i > 0 then
               begin
                    inc(pAj1, i - 1);
                    inc(pA1, i - 1);
                    for k := i - 1 downto 0 do
                    begin
                         sum := sum - pA1^*pAj1^;

                         dec(pA1);
                         dec(pAj1);
                    end;
               end;

               if i = j then
               begin
                    // check for Positive definite matrix
                    if sum <= 0 then
                       exit;

                    PDouble(PAnsiChar(P) + i*LineWidthP)^ := sqrt(sum);
               end
               else
               begin
                    pAj1 := pAj;
                    inc(pAj1, i);
                    pAj1^ := sum/PDouble(PAnsiChar(P) + i*LineWidthP)^;
               end;

               inc(PByte(pAj), LineWidthA);
          end;

          inc(PByte(pA), LineWidthA);
     end;

     if Assigned(progress) then
        progress(100);

     Result := crOk;
end;

function MatrixCholesky(dest : PDouble; const LineWidthDest : integer; A : PDouble; const LineWidthA : integer;
  width : integer; P : PDouble; const LineWidthP : integer; progress : TLinEquProgress) : TCholeskyResult;
var pDest : PDouble;
    pA : PDouble;
    i : integer;
begin
     // copy A to dest
     pA := A;
     pDest := Dest;
     for i := 0 to width - 1 do
     begin
          Move(pA^, pDest^, sizeof(double)*width);
          inc(PByte(pDest), LineWidthDest);
          inc(PByte(pA), LineWidthA);
     end;

     Result := MatrixCholeskyInPlace(dest, LineWidthDest, width, P, LineWidthP, progress);
end;

procedure MatrixCholeskySolveLinEq(A : PDouble; const LineWidthA : integer; width : integer; P : PDouble;
  const LineWidthP : integer; B : PDouble; const LineWidthB : integer; X : PDouble; const LineWidthX : integer;
  progress : TLinEquProgress);
var i, k : integer;
    sum : double;
    pX : PDouble;
    pXi : PDouble;
    pA : PDouble;
    pB : PDouble;
    pP : PDouble;
begin
     pB := B;
     pP := P;
     pXi := X;

     if Assigned(progress) then
        progress(0);

     // Solve L*y = b
     for i := 0 to width - 1 do
     begin
          sum := pB^;
          if i > 0 then
          begin
               pX := pXi;
               dec(PByte(pX), LineWidthX);
               pA := A;
               inc(PByte(pA), i*LineWidthA);
               inc(pA, i - 1);
               for k := i - 1 downto 0 do
               begin
                    sum := sum - pA^*pX^;
                    dec(pA);
                    dec(PByte(pX), LineWidthX);
               end;
          end;

          pXi^ := sum/pP^;

          inc(PByte(pB), LineWidthB);
          inc(PByte(pP), LineWidthP);
          inc(PByte(pXi), LineWidthX);
     end;

     if Assigned(progress) then
        progress(50);

     // Solve L' * x = y
     pP := P;
     inc(PByte(pP), (width - 1)*LineWidthP);
     pXi := X;
     inc(PByte(pXi), (width - 1)*LineWidthX);
     for i := width - 1 downto 0 do
     begin
          sum := pXi^;
          pX := pXi;

          if i < width - 1 then
          begin
               inc(PByte(pX), LineWidthX);

               pA := A;
               inc(pA, i);
               inc(PByte(pA), (i + 1)*LineWidthA);

               for k := i + 1 to width - 1 do
               begin
                    sum := sum - pA^*pX^;
                    inc(PByte(pX), LineWidthX);
                    inc(PByte(pA), LineWidthA);
               end;
          end;

          pXi^ := sum/pP^;
          dec(PByte(pP), LineWidthP);
          dec(PByte(pXi), LineWidthX);
     end;

     if Assigned(progress) then
        progress(100);
end;

function MatrixQRDecompInPlace(A : PDouble; const LineWidthA : integer; width : integer; C : PDouble; const LineWidthC : integer;
  D : PDouble; const LineWidthD : integer; progress : TLinEquProgress) : TQRResult;
var i, j, k : integer;
    scale, sigma, sum, tau : double;
    pA, pAj : PDouble;
    pC : PDouble;
    pD : PDouble;
    pAk : PDouble;
begin
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');
     assert(LineWidthC >= sizeof(double), 'Dimension error');
     assert(LineWidthD >= sizeof(double), 'Dimension error');
     Result := qrOK;

     if Assigned(progress) then
        progress(0);

     pC := C;
     pD := D;
     pAk := A;
     for k := 0 to width - 2 do
     begin
          if Assigned(progress) then
             progress(Int64(k)*100 div width);

          scale := 0;
          pA := pAk;
          for i := k to width - 1 do
          begin
               scale := Max(scale, abs(pA^));
               inc(PByte(pA), LineWidthA);
          end;

          if scale = 0 then
          begin
               Result := qrSingular;
               pC^ := 0;
               pD^ := 0;
          end
          else
          begin
               pA := pAk;
               for i := k to width - 1 do
               begin
                    pA^ := pA^/scale;
                    inc(PByte(pA), LineWidthA);
               end;

               sum := 0;
               pA := pAk;
               for i := k to width - 1 do
               begin
                    sum := sum + sqr(pA^);
                    inc(PByte(pA), LineWidthA);
               end;

               sigma := sign(sqrt(sum), pAk^);
               pAk^ := pAk^ + sigma;
               pC^ := sigma*pAk^;
               pD^ := -scale*sigma;

               for j := k + 1 to width - 1 do
               begin
                    sum := 0;
                    pA := pAk;

                    pAj := pAk;
                    inc(pA, j - k);

                    for i := k to width - 1 do
                    begin
                         sum := sum + pA^*pAj^;
                         inc(PByte(pA), LineWidthA);
                         inc(PByte(pAj), LineWidthA);
                    end;

                    tau := sum/pC^;
                    pA := pAk;

                    pAj := pAk;
                    inc(pAj, j - k);
                    for i := k to width - 1 do
                    begin
                         pAj^ := pAj^ - tau*pA^;
                         inc(PByte(pA), LineWidthA);
                         inc(PByte(pAj), LineWidthA);
                    end;
               end;
          end;

          inc(PByte(pC), LineWidthC);
          inc(PByte(pD), LineWidthD);
          inc(pAk);
          inc(PByte(pAk), LineWidthA);
     end;

     pD := D;
     inc(PByte(pD), (width - 1)*LineWidthD);
     pA := A;
     inc(pA, width - 1);
     inc(PByte(pA), (width - 1)*LineWidthA);
     pD^ := pA^;
     if pD^ = 0 then
        Result := qrSingular;

     if Assigned(Progress) then
        progress(100);
end;

function MatrixQRDecomp(dest : PDouble; const LineWidthDest : integer; A : PDouble; const LineWidthA : integer; width : integer;
  C : PDouble; const LineWidthC : integer; D : PDouble; const LineWidthD : integer; progress : TLinEquProgress) : TQRResult;
var pDest : PDouble;
    pA : PDouble;
    i : integer;
begin
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');
     assert(LineWidthDest >= width*sizeof(double), 'Dimension error');
     assert(LineWidthC >= sizeof(double), 'Dimension error');
     assert(LineWidthD >= sizeof(double), 'Dimension error');

     // copy A to dest
     pA := A;
     pDest := Dest;
     for i := 0 to width - 1 do
     begin
          Move(pA^, pDest^, sizeof(double)*width);
          inc(PByte(pDest), LineWidthDest);
          inc(PByte(pA), LineWidthA);
     end;

     Result := MatrixQRDecompInPlace(dest, LineWidthDest, width, C, LineWidthC, D, LineWidthD, progress);
end;


procedure MatrixRSolve(A : PDouble; const LineWidthA : integer; width : integer; C : PDouble; const LineWidthC;
  D : PDouble; const LineWidthD : integer; B : PDouble; const LineWidthB : integer; progress : TLinEquProgress);
var i, j : integer;
    pA : PDouble;
    pAj : PDouble;
    pB : PDouble;
    pBj : PDOuble;
    pD : PDouble;
    sum : double;
begin
     pBj := B;
     inc(PByte(pBj), LineWidthB*(width - 1));
     pD := D;
     inc(PByte(pD), LineWidthD*(width - 1));
     pBj^ := pBj^/pD^;
     pAj := A;
     inc(PByte(pAj), (width - 2)*LineWidthA);
     inc(pAj, (width - 1));

     if Assigned(progress) then
        progress(0);

     for i := width - 2 downto 0 do
     begin
          sum := 0;

          pA := pAj;
          pB := pBj;
          for j := i + 1 to width - 1 do
          begin
               sum := sum + pA^*pB^;
               inc(pA);
               inc(PByte(pB), LineWidthB);
          end;

          dec(PByte(pBj), LineWidthB);
          dec(PByte(pD), LineWidthD);
          pBj^ := (pBj^ - sum)/pD^;

          dec(pAj);
          dec(PByte(pAj), LineWidthA);
     end;

     if Assigned(progress) then
        progress(100);
end;

procedure MatrixQRSolveLinEq(A : PDouble; const LineWidthA : integer; width : integer; C : PDouble; const LineWidthC : integer;
  D : PDouble; const LineWidthD : integer; B : PDouble; const LineWidthB : integer; progress : TLinEquProgress);
var i, j : integer;
    sum, tau : double;
    pA : PDouble;
    pAj : PDouble;
    pB : PDouble;
    pBj : PDOuble;
    pC : PDouble;
begin
     assert(LineWidthA >= width*sizeof(double), 'Dimension error');
     assert(LineWidthB >= sizeof(double), 'Dimension error');
     assert(LineWidthC >= sizeof(double), 'Dimension error');
     assert(LineWidthD >= sizeof(double), 'Dimension error');

     pAj := A;
     pBj := B;
     pC := C;

     for j := 0 to width - 2 do
     begin
          sum := 0;
          pA := pAj;
          pB := pBj;
          for i := j to width - 1 do
          begin
               sum := sum + pA^*pB^;
               inc(PByte(pA), LineWidthA);
               inc(PByte(pB), LineWidthB);
          end;

          tau := sum/pC^;

          pA := pAj;
          pB := pBj;
          for i := j to width - 1 do
          begin
               pB^ := pB^ - tau*pA^;
               inc(PByte(pB), LineWidthB);
               inc(PByte(pA), LineWidthA);
          end;

          inc(pAj);
          inc(PByte(pAj), LineWidthA);
          inc(PByte(pC), LineWidthC);
          inc(PByte(pBj), LineWidthB);
     end;

     MatrixRSolve(A, LineWidthA, width, C, LineWidthC, D, LineWidthD, B, LineWidthB, progress);
end;


// ##########################################################
// #### Blocked QR Decomposition methods
// ##########################################################

// apply householder transformation to A (one column)
// original DLARFG in Lapack
function GenElemHousholderRefl(A : PDouble; LineWidthA : integer; Height : integer; var Alpha : double; Tau : PDouble) : boolean;
var beta : double;
    xNorm : double;
    //saveMin : double;
begin
     Result := False;
     if height < 1 then
     begin
          Tau^ := 0;
          Result := true;
          exit;
     end;

     xNorm := MatrixElementwiseNorm2(A, LineWidthA, 1, height);
     if xNorm = 0 then
     begin
          // H = I
          Tau^ := 0;
          exit;
     end;

     beta := -sign( pythag(alpha, xnorm), alpha);

     // todo: apply under/overflow code here as lapack does
     // check for possible under/overflow -> rescale
     //saveMin := cMinDblDivEps;
//     // note this is not the original code
//     if Abs(beta) < saveMin then
//     begin
//          // todo:
//     end;

     Tau^ := (beta - alpha)/beta;
     MatrixScaleAndAdd(A, LineWidthA, 1, Height, 0, 1/(alpha - beta));

     alpha := beta;

     Result := True;
end;


// original Dlarf in lapack
procedure ApplyElemHousholderRefl(A : PDouble; LineWidthA : integer; width, height : integer; Tau : PDouble; Work : PDouble);
var pA1 : PDouble;
    x, y : Integer;
    pDest : PDouble;
    pWork : PDouble;
    pA : PDouble;
    tmp : double;
begin
     // work = A(1:m, 2:n)T*A(1:m, 1)
     if tau^ <> 0 then
     begin
          pA1 := A;
          inc(pA1);

          // todo: there is some other scanning going on for non zero columns...
          // do the basic operation here...
          GenericTranspMtxMult(work, sizeof(double), pA1, A, width - 1, height, 1, height, LineWidthA,
                                                   LineWidthA);

          // dger: A - tau*A(1:m,1)*work -> do not touch first column
          pA := A;
          for y := 0 to height - 1 do
          begin
               pDest := pA1;
               pWork := work;
               tmp := tau^*pA^;
               for x := 1 to width - 1 do
               begin
                    pDest^ := pDest^ - tmp*pwork^;
                    inc(pDest);
                    inc(pWork);
               end;

               inc(PByte(pA1), LineWidthA);
               inc(PByte(pA), LineWidthA);
          end;
     end;
end;

// implementation of lapack's DGEQR2
function MtxQRUnblocked(A : PDouble; LineWidthA : TASMNativeInt; width, height : TASMNativeInt; Tau : PDouble; const qrData : TRecMtxQRDecompData) : boolean;
var k : integer;
    i : integer;
    pA : PDouble;
    pTau : PDouble;
    aii : double;
    pAlpha : PDouble;
    lineRes : boolean;
begin
     Result := true;
     k := min(width, height);

     pA := A;
     pTau := Tau;
     for i := 0 to k - 1 do
     begin
          // Generate elemetary reflector H(i) to annihilate A(1+i:height-1,i);
          pAlpha := pA;
          if i < height - 1 then
             inc(PByte(pA), LineWidthA);

          lineRes := GenElemHousholderRefl(pA, LineWidthA, height - i - 1, pAlpha^, pTau);
          Result := Result and lineRes;

          // Apply H(i) to A(i:m,i+1:n) from the left
          if i < width - 1 then
          begin
               aii := pAlpha^;
               pAlpha^ := 1;

               ApplyElemHousholderRefl(pAlpha, LineWidthA, width - i, height - i, pTau, qrData.work);

               pAlpha^ := aii;
          end;

          if Assigned(qrData.Progress) then
             qrData.Progress((qrData.actIdx + i)*100 div qrData.qrWidth);

          inc(pTau);
          inc(pA);
     end;
end;


// original DLARFT in Lapack
procedure CreateTMtx(n, k : integer; A : PDouble; LineWidthA : TASMNativeInt; Tau : PDouble; const qrData : TRecMtxQRDecompData);
var i, j : Integer;
    pT, pA : PDouble;
    pA1 : PDouble;
    pDest : PDouble;
    pT1, pt2 : PDouble;
    x, y : integer;
    tmp : Double;
    pMem : PDouble;
    pResVec : PDouble;
    T : PDouble;
begin
     assert(k <= n, 'Error k needs to be smaller than n');

     // it is assumed that mem is a memory block of at least (n, k) where the first (k, k) elements are reserved for T
     T := qrData.work;
     pMem := T;
     inc(PByte(pMem), k*qrData.LineWidthWork);

     for i := 0 to k - 1 do
     begin
          if Tau^ = 0 then
          begin
               // H = I
               pT := T;
               for j := 0 to i do
               begin
                    pT^ := 0;
                    inc(PByte(pT), qrData.LineWidthWork);
               end;
          end
          else
          begin
               // general case

               // T(1:i-1,i) := - tau(i) * A(i:j,1:i-1)**T * A(i:j,i)          **T = Transposed

               // T(1:i-1,i) := - tau(i) * V(i:n,1:i-1)' * V(i:n,i) */

               pA1 := A;
               inc(PByte(pA1), LineWidthA*i); // i + 1);

               // precalculate -tau*v for the vector T
               pA := A;
               inc(pA, i);
               inc(PByte(pA), (i+1)*LineWidthA);
               pResVec := pMem;
               pResVec^ := -Tau^;   // first element of V is 1!
               inc(pResVec);
               for j := i + 1 to n - 1 do   // do not calculate the rest they are gona be multiplied with 0
               begin
                    pResVec^ := -Tau^*pA^;
                    inc(pResVec);
                    inc(PByte(pA), LineWidthA);
               end;
               pT := T;
               inc(pT, i);

               // final -tau * Y' * v  ->
               // todo: Implement an optimized matrix vector operator for mt1'mt2
               GenericTranspMtxMult(pT, qrData.LineWidthWork, pA1, pMem, k, n - i, 1, n - i, LineWidthA, sizeof(double));
          end;

          // dtrmv: upper triangle matrix mult T(1:i-1,i) := T(1:i-1, 1:i-1)*T(1:i-1,i)
          if i > 0 then
          begin
               pDest := T;
               inc(pDest, i);
               for y := 0 to i - 1 do
               begin
                    pT1 := T;
                    inc(pT1, y);
                    inc(PByte(pT1), y*qrData.LineWidthWork);

                    pT2 := pDest;
                    tmp := 0;
                    for x := y to i - 1 do
                    begin
                         tmp := tmp + pT1^*pT2^;
                         inc(pT1);
                         inc(PByte(pT2), qrData.LineWidthWork);
                    end;

                    pDest^ := tmp;
                    inc(PByte(pDest), qrData.LineWidthWork);
               end;
          end;

          pT := T;
          inc(pT, i);
          inc(PByte(pT), i*qrData.LineWidthWork);
          pT^ := Tau^;  // fill in last Tau

          inc(Tau);
     end;
end;

procedure MatrixSubT(A : PDouble; LineWidthA : TASMNativeInt; B : PDouble; LineWidthB : TASMNativeInt; width, height : TASMNativeInt);
var x, y : TASMNativeInt;
    pA, pB : PDouble;
begin
     // calculate A = A - B'
     for y := 0 to height - 1 do
     begin
          pA := A;
          pB := B;
          for x := 0 to width - 1 do
          begin
               pA^ := pA^ - pB^;
               inc(pA);
               inc(PByte(pB), LineWidthB);
          end;

          inc(PByte(A), LineWidthA);
          inc(B);
     end;
end;

// apply block reflector to a matrix
// original DLARFB in Lapack
procedure ApplyBlockReflector(A : PDouble; LineWidthA : integer; const qrData : TRecMtxQRDecompData;
  width, height : integer; widthT : integer; Transposed : boolean);
var pC1, pC2 : PDouble;
    pY1, pY2 : PDouble;
    T : PDouble;
    LineWidthT : TASMNativeInt;
    mem : PDouble;
    LineWidthMem : TASMNativeInt;
    heightW : integer;
begin
     mem := qrData.work;
     inc(PByte(mem), widthT*qrData.LineWidthWork);  // upper part (nb x nb) is dedicated to T, lower part to W in dlarfb
     LineWidthMem := qrData.LineWidthWork;

     T := qrData.work;
     LineWidthT := qrData.LineWidthWork;

     // (I - Y*T*Y')xA_trailing
     pY1 := A;
     pY2 := A;
     inc(PByte(pY2), widthT*LineWidthA);
     pC1 := A;
     inc(pC1, widthT);
     pC2 := pC1;
     inc(PByte(pC2), widthT*LineWidthA);

     // W = C1'*Y1
     GenericMtxMultTria2T1(mem, LineWidthMem, pC1, LineWidthA, pY1, LineWidthA, width - widthT, widthT, widthT, widthT);
     heightW := width - widthT;

     // W = W + C2'*Y2
     qrData.MatrixMultT1(mem, LineWidthMem, pC2, pY2, Width - WidthT, height - widthT, WidthT, height - widthT, LineWidthA, LineWidthA, QRMultBlockSize, doAdd, qrData.BlkMultMem);

     // W = W * T (using dtrm)  or W = W*T'
     if height > widthT then
     begin
          if transposed
          then
              GenericMtxMultTria2T1StoreT1(mem, LineWidthMem, T, LineWidthT, widthT, heightW, WidthT, WidthT)
          else
              GenericMtxMultTria2Store1(mem, LineWidthMem, T, LineWidthT, widthT, heightW, WidthT, WidthT);

          // C2 = C2 - Y2*W'
          qrData.MatrixMultT2(pC2, LineWidthA, pY2, mem, widthT, height - widthT, widthT, heightW, LineWidthA, LineWidthMem, QRMultBlockSize, doSub, qrData.BlkMultMem);

          // W = W*Y1' (lower left part of Y1! -> V1)
          GenericMtxMultLowTria2T2Store1(mem, LineWidthMem, A, LineWidthA, WidthT, heightW, widthT, widthT);
     end;

     // C1 = C1 - W'
     MatrixSubT(pC1, LineWidthA, mem, LineWidthMem, width - widthT, widthT);
end;

function InternalMatrixQRDecompInPlace2(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; qrData : TRecMtxQRDecompData) : boolean;
var k : TASMNativeInt;
    idx : TASMNativeInt;
    ib : TASMNativeInt;
    pA : PDouble;
    pnlRes : boolean;
begin
     // ######################################################
     // #### original linpack DGEQRF routine
     k := Min(width, height);

     // check if the panel size fits the width/heigth -> if not adjust the panel size
     if (qrdata.pnlSize > 1) and (qrdata.pnlSize > k) then
        qrdata.pnlSize := max(2, k div 2);

     Result := True;
     qrData.LineWidthWork := sizeof(double)*qrdata.pnlSize;
     idx := 0;
     pA := A;

     if (qrdata.pnlSize >= 2) and (qrdata.pnlSize < k) then
     begin
          // calculate the qr decomposition for the current panel
          while idx < k - qrdata.pnlSize - 2 do
          begin
               ib := min(width - idx, qrdata.pnlSize);

               pnlRes := MtxQRUnblocked(pA, LineWidthA, ib, height - idx, Tau, qrData);
               Result := Result and pnlRes;

               // calculate T matrix
               if idx + ib <= height then
               begin
                    CreateTMtx(height - idx, ib, pA, LineWidthA, Tau, qrData);

                    // apply H to A from the left
                    ApplyBlockReflector(pA, LineWidthA, qrData, width - idx, height - idx, ib, False);
               end;

               inc(qrData.actIdx, ib);

               inc(pA, ib);
               inc(PByte(pA),ib*LineWidthA);
               inc(idx, ib);
               inc(Tau, ib);
          end;
     end;

     // calculate the last panel
     pnlRes := MtxQRUnblocked(pA, LineWidthA, width - idx, height - idx, Tau, qrData);
     Result := Result and pnlRes;
end;

function MatrixQRDecompInPlace2(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; progress : TLinEquProgress = nil) : TQRResult; overload;
begin
     Result := MatrixQRDecompInPlace2(A, LineWidthA, width, height, tau, nil, QRBlockSize, Progress);
end;

function MatrixQRDecompInPlace2(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; work : PDouble; pnlSize : integer; progress : TLinEquProgress = nil) : TQRResult; overload;
var res : boolean;
    qrData : TRecMtxQRDecompData;
begin
     qrData.pWorkMem := nil;
     qrData.work := work;
     qrData.BlkMultMem := nil;
     qrData.Progress := progress;
     qrData.qrWidth := width;
     qrData.qrHeight := height;
     qrData.actIdx := 0;
     qrData.pnlSize := pnlSize;
     qrData.MatrixMultT1 := {$IFDEF FPC}@{$ENDIF}MatrixMultT1Ex;
     qrData.MatrixMultT2 := {$IFDEF FPC}@{$ENDIF}MatrixMultT2Ex;

     if work = nil then
     begin
          qrData.pWorkMem := GetMemory(pnlSize*sizeof(double)*height + 64 + BlockMultMemSize(QRMultBlockSize) );
          qrData.work := PDouble(qrData.pWorkMem);
          if (NativeUInt(qrData.pWorkMem) and $0000000F) <> 0 then
             qrData.work := PDouble(NativeUInt(qrData.pWorkMem) + 16 - NativeUInt(qrData.pWorkMem) and $0F);
     end;

     // it's assumed that the work memory block may also be used
     // as blocked multiplication memory storage!
     qrData.BlkMultMem := qrData.work;
     inc(qrData.BlkMultMem, pnlSize*height);

     res := InternalMatrixQRDecompInPlace2(A, LineWidthA, width, height, tau, qrData);

     if work = nil then
        FreeMem(qrData.pWorkMem);

     if res
     then
         Result := qrOK
     else
         Result := qrSingular;
end;

// generates an m by n real matrix Q with orthonormal columns,
//  which is defined as the first n columns of a product of k elementary
//  reflectors of order m
// k: the number of elemetary reflectors whose product defines the matrix Q. width >= K >= 0.
// original dorg2r from netlib
procedure InternalMatrixQFromQRDecomp(A : PDouble; const LineWidthA : TASMNativeInt; width, height, k : TASMNativeInt; tau : PDouble; const qrData : TRecMtxQRDecompData);
var pA : PDouble;
    pAii : PDouble;
    i, j : integer;
begin
     if width <= 0 then
        exit;

     // Initialise columns k+1:n to columns of the unit matrix
     for j := k to width - 1 do
     begin
          pA := A;
          inc(pA, j);

          for i := 0 to height - 1 do
          begin
               pA^ := 0;
               inc(PByte(pA), LineWidthA);
          end;

          pA := A;
          inc(pA, j);
          inc(PByte(pA), j*LineWidthA);
          pA^ := 1;
     end;

     // Apply H(i) to A(i:m,i:n) from the left
     inc(tau, k - 1);
     for i := k - 1 downto 0 do
     begin
          if i < width - 1 then
          begin
               pAii := A;
               inc(pAii, i);
               inc(PByte(pAii), i*LineWidthA);

               pAii^ := 1;
               ApplyElemHousholderRefl(pAii, LineWidthA, width - i, height - i, tau, qrData.work);
          end;

          // unscaling
          if i < height - 1 then
          begin
               pAii := A;
               inc(pAii, i);
               inc(PByte(pAii), (i+1)*LineWidthA);

               MatrixScaleAndAdd(pAii, LineWidthA, 1, height - i - 1, 0, -tau^);
          end;

          pAii := A;
          inc(pAii, i);
          inc(PByte(pAii), i*LineWidthA);
          pAii^ := 1 - tau^;

          // Set A(1:i-1,i) to zero
          pA := A;
          inc(pA, i);
          for j := 0 to i - 1 do
          begin
               pA^ := 0;
               inc(PByte(pA), LineWidthA);
          end;

          dec(tau);

          // ###########################################
          // #### Progress
          if Assigned(qrData.Progress) then
             qrData.Progress((qrData.actIdx + i)*100 div qrData.qrWidth);
     end;
end;

procedure InternalBlkMatrixQFromQRDecomp(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; tau : PDouble; qrData : TRecMtxQRDecompData);
var pA : PDouble;
    x, y : integer;
    numIter : integer;
    pTau : PDouble;
    counter: Integer;
    idx : integer;
begin
     // check for quick return ???
     if width <= 0 then
     begin
          qrData.work^ := 1;
          exit;
     end;

     // restrict block size...
     qrData.pnlSize := min(height, min(width, qrData.pnlSize));

     // zero out block not used by Q
     if height < width then
     begin
          for y := 0 to height - 1 do
          begin
               pA := A;
               inc(pA, height);
               inc(PByte(pA), y*LineWidthA);

               for x := height to width - 1 do
               begin
                    pA^ := 0;
                    inc(pA);
               end;
          end;

          // from here on we can do a normal q factorization
          width := height;
     end;

     if qrData.pnlSize = width then
     begin
          // unblocked code
          InternalMatrixQFromQRDecomp(A, LineWidthA, width, height, width, tau, qrData);
     end
     else
     begin
          numIter := (width div qrData.pnlSize);
          // apply unblocked code to the last block
          if numIter*qrData.pnlSize < width then
          begin
               idx := numIter*qrData.pnlSize;
               pA := A;
               inc(pA, idx);
               inc(PByte(pA), LineWidthA*idx);
               pTau := tau;
               inc(pTau, idx);
               InternalMatrixQFromQRDecomp(pA, LineWidthA, width - idx, height - idx, width - idx, pTau, qrData);

               // Set upper rows of current block to zero
               for y := 0 to idx - 1 do
               begin
                    pA := A;
                    inc(pA, idx);
                    inc(PByte(pA), LineWidthA*y);
                    for x := 0 to width - idx - 1 do
                    begin
                         pA^ := 0;
                         inc(pA);
                    end;
               end;
          end;

          // blocked code:
          for counter := numIter - 1 downto 0 do
          begin
               idx := counter*qrdata.pnlSize;
               pA := A;
               inc(pA, idx);
               inc(PByte(pA), idx*LineWidthA);
               pTau := tau;
               inc(pTau, idx);

               if (counter + 1)*qrdata.pnlSize < width then
               begin
                    // form triangular factor of the block reflector
                    // H = H(i) H(i+1) . . . H(i+ib-1)
                    // calculate T matrix
                    CreateTMtx(height - idx, qrData.pnlSize, pA, LineWidthA, pTau, qrData);
                    // apply H to A from the left
                    ApplyBlockReflector(pA, LineWidthA, qrData, width - idx, height - idx, qrdata.pnlSize, True);
               end;

               InternalMatrixQFromQRDecomp(pA, LineWidthA, qrData.pnlSize, height - idx, qrData.pnlSize, pTau, qrData);

               // Set upper rows of current block to zero
               for y := 0 to idx - 1 do
               begin
                    pA := A;
                    inc(pA, idx);
                    inc(PByte(pA), LineWidthA*y);
                    for x := 0 to qrData.pnlSize - 1 do
                    begin
                         pA^ := 0;
                         inc(pA);
                    end;
               end;
          end;
     end;
end;

procedure MatrixQFromQRDecomp(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; 
  tau : PDouble; progress : TLinEquProgress = nil); overload;
begin
     MatrixQFromQRDecomp(A, LineWidthA, width, height, tau, QRBlockSize, nil, progress);
end;

procedure MatrixQFromQRDecomp(A : PDouble; const LineWidthA : TASMNativeInt; width, height : TASMNativeInt; 
 tau : PDouble; BlockSize : integer; work : PDouble; progress : TLinEquProgress = nil);
var qrData : TRecMtxQRDecompData;
begin
     qrData.pWorkMem := nil;
     qrData.work := work;
     qrData.BlkMultMem := nil;
     qrData.Progress := progress;
     qrData.qrWidth := width;
     qrData.qrHeight := height;
     qrData.actIdx := 0;
     qrData.pnlSize := BlockSize;
     qrData.LineWidthWork := sizeof(double)*qrdata.pnlSize;
     qrData.MatrixMultT1 := {$IFDEF FPC}@{$ENDIF}MatrixMultT1Ex;
     qrData.MatrixMultT2 := {$IFDEF FPC}@{$ENDIF}MatrixMultT2Ex;

     if work = nil then
     begin
          qrData.pWorkMem := GetMemory(qrData.pnlSize*sizeof(double)*height + 64 + BlockMultMemSize(QRMultBlockSize) );
          qrData.work := PDouble(qrData.pWorkMem);
          if (NativeUInt(qrData.pWorkMem) and $0000000F) <> 0 then
             qrData.work := PDouble(NativeUInt(qrData.pWorkMem) + 16 - NativeUInt(qrData.pWorkMem) and $0F);
     end;

     // it's assumed that the work memory block may also be used
     // as blocked multiplication memory storage!
     qrData.BlkMultMem := qrData.work;
     inc(qrData.BlkMultMem, qrData.pnlSize*height);

     InternalBlkMatrixQFromQRDecomp(A, LineWidthA, width, height, tau, qrData);
     if not Assigned(work) then
        freeMem(qrData.pWorkMem);
end;

end.

