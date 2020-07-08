function complete = comparison_figure
    % Produces outlines for Figure 3A in Mehra et. al. 2020
    close all
    complete = false;
    
    figure;
    
    hold on
    
    % Gigantosponia
    
    % Walls
    
    line([300, 1000], [0,0]);
    
    text(0, 0, 'G. discoforma walls ->', 'FontSize', 8);
    
    % Tubules
    
    line([700, 1200], [0.5,0.5]);
    
    text(0, 0.5, 'G. discoforma tubules ->', 'FontSize', 8);
    
    % A. perforata skeleton and void (this paper)
    
    % 25th and 75th percentiles
    
    line([280, 396], [1,1]);
    
    text(0, 1, 'A. perforata sk. ->', 'FontSize', 8);
    
    % Median
    
    scatter(330, 1);
    
    % Void
    
    % 25th and 75th percentiles
    
    line([268, 351], [1.5, 1.5]);
    
    % Median
    
    scatter(312, 1.5);
    
    text(0, 1.5, 'A. perforata void ->', 'FontSize', 8);

    % V. crypta walls, from Recent Sphinctozoa, Order Verticillitida, Family Verticillitidae Steinmann, 1882
    
    scatter(50, 2);
 
    % V crypta chamber size
    
    line([600, 900], [2,2]);
    
    text(150, 2, '<- walls | V. crypta | chamber ->', 'FontSize', 8);
    
    % A seunesi tubule diameter
    
    line([800, 1100], [3, 3]);
    
    text(0, 3, 'A. seunesi tubules ->', 'FontSize', 8);

    ylim([-1, 4]);
    
    pbaspect([4.5, 1.4, 1]);
    
    print('./comparison_outline.eps', '-painters', '-depsc');
    
    complete = true;
end