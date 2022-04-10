--
function c29010213.initial_effect(c)
   --Activate
   local e1=Effect.CreateEffect(c) 
   e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e1:SetCountLimit(1,29010213+EFFECT_COUNT_CODE_OATH)
   e1:SetTarget(c29010213.actg)
   e1:SetOperation(c29010213.acop)
   c:RegisterEffect(e1)
end
function c29010213.ctfil(c)
   return c:IsAbleToDeckAsCost() and c:IsSetCard(0x17af)  
end
function c29010213.gck(g,e,tp) 
   return Duel.IsExistingTarget(c29010213.spfil,tp,LOCATION_GRAVE,0,1,g,e,tp)
end
function c29010213.spfil(c,e,tp)
   return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c29010213.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
   local g=Duel.GetMatchingGroup(c29010213.ctfil,tp,LOCATION_REMOVED,0,nil)
   if chk==0 then return g:CheckSubGroup(c29010213.gck,5,5,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
   local dg=g:SelectSubGroup(tp,c29010213.gck,false,5,5,e,tp)
   Duel.SendtoDeck(dg,nil,2,REASON_COST)
   local sg=Duel.SelectTarget(tp,c29010213.spfil,tp,LOCATION_GRAVE,0,1,1,dg,e,tp)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function c29010213.acop(e,tp,eg,ep,ev,re,r,rp)  
   local c=e:GetHandler()
   local tc=Duel.GetFirstTarget() 
   if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
   if Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29010213,0)) then 
   local sg=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
   Duel.GetControl(sg,tp)
   end 
   end 
end