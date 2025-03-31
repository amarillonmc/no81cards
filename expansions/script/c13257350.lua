--梦超时空战斗机-射命丸 文
local m=13257350
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableCounterPermit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB)
	c:SetCounterLimit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetOperation(cm.atop)
	c:RegisterEffect(e0)
	--[[
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.pccon)
	e3:SetTarget(cm.pctg)
	e3:SetOperation(cm.pcop)
	c:RegisterEffect(e3)
	]]
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,6))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetTarget(cm.bombtg)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	eflist={{"power_capsule",e3},{"bomb",e4}}
	cm[c]=eflist
	
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x351) and c:IsAbleToHandAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,7))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.Equip(tp,tc,c)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1) then
		e:GetHandler():AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	end
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.pcfilter,1,nil,1-tp)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:SetCategory(CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Equip(tp,tc,c)
	end
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST)
end
function cm.rfilter(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function cm.efilter(e,te)
	return e:GetHandler()~=te:GetOwner() and not te:GetOwner():IsType(TYPE_EQUIP)
end
function cm.desfilter0(c,p)
	return (c:IsType(TYPE_TOKEN) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsControler(p)
end
function cm.desfilter(c)
	return (c:IsFaceup() and ((c:IsAttackBelow(0) or c:IsDefenseBelow(0)) or c:IsType(TYPE_TOKEN)))
		or c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetHandler():GetColumnGroup():Filter(cm.desfilter0,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	e5:SetValue(500)
	c:RegisterEffect(e5)

	local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		while tc do
			if tc:IsFaceup() and tc:IsType(TYPE_MONSTER) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(-800)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
			end
			tc=g:GetNext()
		end
	end
	local sg=g:Filter(cm.desfilter,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,7))
end
