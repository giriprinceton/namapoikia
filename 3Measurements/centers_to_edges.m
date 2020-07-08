function edges = centers_to_edges(centers)
    % Convert centers to edges
    d = diff(centers)/2;
    edges = [centers(1)-d(1), centers(1:end-1)+d, centers(end)+d(end)];
    edges(2:end) = edges(2:end)+eps(edges(2:end));
end