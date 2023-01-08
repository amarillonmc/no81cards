--社恐吉他手
function c79014030.initial_effect(c)
	aux.AddCodeList(c,79014030)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--pos and set
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_POSITION) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetTarget(c79014030.pstg) 
	e1:SetOperation(c79014030.psop) 
	c:RegisterEffect(e1) 
end 
function c79014030.pstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanChangePosition() end 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end 
function c79014030.setfil(c) 
	return c:IsSSetable() and aux.IsCodeListed(c,79014030) and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end 
function c79014030.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c79014030.setfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79014030,0)) then
		local g=Duel.SelectMatchingCard(tp,c79014030.setfil,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SSet(tp,g) 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
















