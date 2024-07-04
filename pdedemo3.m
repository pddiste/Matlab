%% Minimal Surface Problem on the Unit Disk
% This example shows how to solve a nonlinear elliptic problem.

%       Copyright 1994-2015 The MathWorks, Inc.

%% A Nonlinear PDE
% A nonlinear problem is one whose coefficients not only depend on spatial
% coordinates, but also on the solution itself. An example of this is the minimal
% surface equation
%
% $$-\nabla \cdot \left( \frac{1}{\sqrt{1 + \left|\nabla u\right|^2}} \nabla u \right) = 0$$
%
% on the unit disk, with 
%
% $u(x,y) = x^2$ 
%
% on the boundary. To express this equation in toolbox form, note that the
% elliptic equation in toolbox syntax is
%
% $$ -\nabla\cdot(c\nabla u) + au = f.$$
%
% The PDE coefficient |c| is the multiplier of $\nabla u$, namely
%
% $$c = \frac{1}{\sqrt{1 + \left|\nabla u\right|^2}}.$$
%
% $c$ is a function of the solution $u$, so the problem is nonlinear. In
% toolbox syntax, you see that the $a$ and $f$ coefficients are 0.



%% Geometry
% Create a PDE Model with a single dependent variable, and include the
% geometry of the unit disk. The |circleg| function represents this
% geometry. Plot the geometry and display the edge labels.

numberOfPDE = 1;
model = createpde(numberOfPDE);
geometryFromEdges(model,@circleg);
pdegplot(model,'EdgeLabels','on'); 
axis equal
title 'Geometry with Edge Labels';

%% Specify PDE Coefficients
a = 0;
f = 0;
cCoef = @(region,state) 1./sqrt(1+state.ux.^2 + state.uy.^2);
specifyCoefficients(model,'m',0,'d',0,'c',cCoef,'a',a,'f',f);

%% Boundary Conditions
% Create a function that represents the boundary condition $u(x,y) = x^2$.
bcMatrix = @(region,~)region.x.^2;
applyBoundaryCondition(model,'dirichlet',...
                             'Edge',1:model.Geometry.NumEdges,...
                             'u',bcMatrix);

%% Generate Mesh
generateMesh(model,'Hmax',0.1);
figure; 
pdemesh(model); 
axis equal

%% Solve PDE
% Because the problem is nonlinear, solvepde invokes nonlinear solver.
% Observe the solver progress by setting the
% |SolverOptions.ReportStatistics| property of |model| to |'on'|.
model.SolverOptions.ReportStatistics = 'on';
result = solvepde(model);
u = result.NodalSolution;

%% Plot Solution
figure; 
pdeplot(model,'XYData',u,'ZData',u);
xlabel 'x'
ylabel 'y'
zlabel 'u(x,y)'
title 'Minimal surface'
