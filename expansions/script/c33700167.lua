--降阶魔法 心之牺牲
function c33700167.initial_effect(c)
	--Activate
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
   e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetCost(c33700167.cost)
   e1:SetTarget(c33700167.target)
   e1:SetOperation(c33700167.activate)
   c:RegisterEffect(e1)
   Duel.AddCustomActivityCounter(33700167,ACTIVITY_SPSUMMON,c33700167.counterfilter)
end
function c33700167.counterfilter(c)
   return c:IsType(TYPE_XYZ)
end
function c33700167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
   e1:SetType(EFFECT_TYPE_FIELD)
   e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
   e1:SetTargetRange(1,0)
   e1:SetTarget(c33700167.splimit)
   e1:SetLabelObject(e)
   e1:SetReset(RESET_PHASE+PHASE_END)
   Duel.RegisterEffect(e1,tp)
end
function c33700167.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
function c33700167.filter(c,e,tp)
   return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
	  and Duel.IsExistingMatchingCard(c33700167.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank(),c:GetOverlayCount(),c:GetRace(),c:GetAttribute())
end

function c33700167.filter2(c,e,tp,tc,rk,og,race,attr)
   return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	  and (c:GetRace()==race or c:GetAttribute()==attr)
	  and c:GetRank()<rk and c:GetRank()>=og
end
function c33700167.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33700167.filter(chkc,e,tp) end
   if chk==0 then return Duel.IsExistingTarget(c33700167.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
   local g=Duel.SelectTarget(tp,c33700167.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
   Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetOverlayCount()*1000)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function c33700167.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   local tc=Duel.GetFirstTarget()
   if not tc or not tc:IsRelateToEffect(e) then return end
   local mg=tc:GetOverlayGroup()
   local ogc=mg:GetCount()
   Duel.SendtoGrave(mg,REASON_EFFECT)
   if ogc>0 and Duel.Recover(tp,ogc*1000,REASON_EFFECT)>0 then
	  if Duel.GetMZoneCount(tp)<=0 then return end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  local g=Duel.SelectMatchingCard(tp,c33700167.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank(),ogc,tc:GetRace(),tc:GetAttribute())
	  local sc=g:GetFirst()
	  if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		 Duel.BreakEffect()
		 Duel.Overlay(sc,Group.FromCards(tc))
	  end
	  	if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(sc,Group.FromCards(c))
		end
   end
end
