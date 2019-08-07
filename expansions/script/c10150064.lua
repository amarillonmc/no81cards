--启辉苏生
function c10150064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150064+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10150064.target)
	e1:SetOperation(c10150064.activate)
	c:RegisterEffect(e1)	
end

function c10150064.filter(c,e,tp,tid)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp) and c:IsLevelAbove(1) and c:GetTurnID()==tid
end
function c10150064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10150064.filter(chkc,e,tp,Duel.GetTurnCount()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10150064.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10150064.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
end
function c10150064.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_UPDATE_LEVEL)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetValue(1)
	   tc:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	   e2:SetRange(LOCATION_MZONE)
	   e2:SetCode(EVENT_PHASE+PHASE_END)
	   e2:SetOperation(c10150064.desop)
	   e2:SetReset(RESET_EVENT+0x1fe0000)
	   e2:SetCountLimit(1)
	   tc:RegisterEffect(e2,true)
	end
end
function c10150064.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end