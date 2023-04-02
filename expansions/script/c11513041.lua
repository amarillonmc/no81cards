--星穹的勇者 维达拉姆
function c11513041.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11513041.matfilter,3)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c11513041.espcon)
	e1:SetOperation(c11513041.espop) 
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c11513041.matval)
	c:RegisterEffect(e1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11513041.splimit)
	c:RegisterEffect(e1) 
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	c:RegisterEffect(e1)
	--immuse 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_IMMUNE_EFFECT) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e2:SetValue(c11513041.efilter) 
	c:RegisterEffect(e2)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e2:SetValue(function(e,c)
	return c~=e:GetHandler() end)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11513041.atkcon) 
	e3:SetOperation(c11513041.atkop)
	c:RegisterEffect(e3) 
	--to deck 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TODECK) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_LEAVE_FIELD) 
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e4:SetCountLimit(1,11513041+EFFECT_COUNT_CODE_DUEL)  
	e4:SetCondition(c11513041.tdcon) 
	e4:SetTarget(c11513041.tdtg) 
	e4:SetOperation(c11513041.tdop) 
	c:RegisterEffect(e4) 
end 
function c11513041.matfilter(c)
	return c:IsLinkType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK+TYPE_RITUAL)
end
function c11513041.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_LINK 
end
function c11513041.rlfil(c,tp,sc)
	return c:IsCode(17469113) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0 
end
function c11513041.espcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	return Duel.IsExistingMatchingCard(c11513041.rlfil,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c11513041.espop(e,tp,eg,ep,ev,re,r,rp,c) 
	local g=Duel.SelectMatchingCard(tp,c11513041.rlfil,tp,LOCATION_MZONE,0,1,1,nil,tp,c) 
	Duel.Release(g,REASON_COST) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) end)
	e1:SetReset(RESET_EVENT+0xff0000) 
	c:RegisterEffect(e1)
end
function c11513041.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c11513041.efilter(e,te)  
	local mg=e:GetHandler():GetMaterial() 
	local flag=0 
	if mg:GetCount()==0 then return false end 
	local tc=mg:GetFirst() 
	while tc do  
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_PENDULUM) then flag=bit.bor(flag,TYPE_PENDULUM) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	if tc:IsType(TYPE_RITUAL) then flag=bit.bor(flag,TYPE_RITUAL) end
	tc=mg:GetNext() 
	end 
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(flag)   
end 
function c11513041.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0   
end 
function c11513041.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then 
		Duel.Hint(HINT_CARD,0,11513041) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1) 
		if aux.NegateEffectMonsterFilter(bc) then 
		Duel.NegateRelatedChain(bc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		bc:RegisterEffect(e2)
		Duel.AdjustInstantly() 
		end 
	end
end
function c11513041.tdcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and (e:GetHandler():IsReason(REASON_BATTLE) or (e:GetHandler():GetReasonPlayer()~=tp and e:GetHandler():IsReason(REASON_EFFECT)))  
end 
function c11513041.tdfil(c) 
	return c:IsAbleToDeck()   
end 
function c11513041.tdgck(g) 
	return g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)<=1 
	   and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1 
	   and g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<=1 
end 
function c11513041.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11513041.tdfil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if chk==0 then return g:CheckSubGroup(c11513041.tdgck,1,3) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end  
function c11513041.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513041.tdfil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if g:CheckSubGroup(c11513041.tdgck,1,3) then 
	local sg=g:SelectSubGroup(tp,c11513041.tdgck,false,1,3) 
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	end 
end 





