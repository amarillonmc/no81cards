--禁钉显迹咎者机
function c20250336.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20250336,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,20250336)
	e1:SetCondition(c20250336.spcon)
	e1:SetTarget(c20250336.sptg)
	e1:SetOperation(c20250336.spop)
	c:RegisterEffect(e1)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20250336,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,20250337)
	e2:SetTarget(c20250336.lvtg)
	e2:SetOperation(c20250336.lvop)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCondition(c20250336.dckcon) 
	e4:SetOperation(c20250336.dckop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CUSTOM+20250336) 
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,20250338)
	e5:SetCondition(c20250336.descon)
	e5:SetTarget(c20250336.target)
	e5:SetOperation(c20250336.activate)
	c:RegisterEffect(e5)
end
function c20250336.spcfilter(tp)
	return Duel.GetCounter(tp,1,0,0x154a)>0
end
function c20250336.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20250336.spcfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c20250336.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20250336.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		c:AddCounter(0x154a,2)
	end
end
function c20250336.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetLevel()>0 and c:GetCounter(0x154a)>=1 end
end
function c20250336.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or c:IsFacedown() then return end
	local down=c:IsLevelAbove(2)
	local lv=aux.SelectFromOptions(tp,{true,aux.Stringid(20250336,2)},{down,aux.Stringid(20250336,3),-1})
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c20250336.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c20250336.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c20250336.dckcon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetFlagEffect(20250336)
	return x~=e:GetHandler():GetCounter(0x154a)
end 
function c20250336.dckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:ResetFlagEffect(20250336)
		local ct=c:GetCounter(0x154a)
		for i=1,ct do
		c:RegisterFlagEffect(20250336,RESET_EVENT+0x1fe0000,0,1)
	end
		if e:GetHandler():GetCounter(0x154a)==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+20250336,e,0,0,tp,0) 
	end
end
function c20250336.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x154a)==0 
end
function c20250336.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
end
function c20250336.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end