# Assumptions and limitations

1. **Synthetic data only.** All entities and amounts are fictional.
2. **Single-year snapshot.** The source opportunity and target data cover 2025. This is enough for practice but not enough to establish seasonality.
3. **Illustrative probabilities.** Stage probabilities are fixed assumptions, not learned from historical conversion.
4. **Bookings vs revenue.** Closed-won ACV is used as a bookings proxy. It is not recognized revenue.
5. **Funnel caveat.** Stage-history reach counts can include opportunities created in different periods. Use cohort-based SQL for true conversion analysis.
6. **Activity completeness.** The activity log is synthetic and does not represent all real sales work.
7. **No CRM API integration.** CSV files simulate exports from CRM objects; no live Salesforce/HubSpot connection exists.
8. **Power BI artifact.** The source package includes a build guide and DAX measures, not a prebuilt PBIX.
9. **Forecast accuracy.** A forecast accuracy measure requires dated forecast snapshots. This dataset does not contain historical forecast snapshots, so the project should not claim forecast accuracy.
10. **Currency.** ACV values are generic numeric units with no currency conversion. Select and label a currency before publishing dashboard screenshots.
