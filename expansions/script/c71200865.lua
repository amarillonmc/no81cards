--杀手级调整曲·母带修音手
function c71200865.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,nil,1,99)
	c:EnableReviveLimit()
	--position change
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c71200865.tdtg)
	e1:SetOperation(c71200865.tdop)
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71200865)
	e2:SetCondition(c71200865.rmdcon) 
	e2:SetTarget(c71200865.rmdtg)
	e2:SetOperation(c71200865.rmdop)
	c:RegisterEffect(e2) 
end
function c71200865.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanTurnSet() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c71200865.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain():Filter(Card.IsType,nil,TYPE_MONSTER)
	if #sg==0 then return end
	Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
end
function c71200865.rmdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)  
end 
function c71200865.rmdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local rc=re:GetHandler()
	if chk==0 then return rc and rc:IsAbleToRemove() end 
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function c71200865.rmdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler() 
	local dchk=false 
	if c:GetMaterialCount()>0 and c:GetMaterialCount()==c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_TUNER) then  
		dchk=true 
	end 
	if rc:IsRelateToEffect(e) and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and dchk and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(71200865,0)) then 
		Duel.NegateEffect(ev)
	end 
end 


