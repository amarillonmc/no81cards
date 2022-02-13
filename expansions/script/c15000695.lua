local m=15000695
local cm=_G["c"..m]
cm.name="创溯之核"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(cm.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm[0]={}
		cm[1]={}
		local att=1
		while att<(ATTRIBUTE_DARK+ATTRIBUTE_DIVINE+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_WIND) do
			cm[0][att]=Group.CreateGroup()  
			cm[0][att]:KeepAlive()  
			cm[1][att]=Group.CreateGroup()  
			cm[1][att]:KeepAlive()
			att=att<<1
		end
	end
end
function cm.rmfilter(c,rc)
	return c:IsFaceup() and c:IsAttribute(rc)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumtype==SUMMON_TYPE_DUAL then return false end
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local att=1
		while att<(ATTRIBUTE_DARK+ATTRIBUTE_DIVINE+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_WIND) do
			local rg=g:Filter(Card.IsAttribute,nil,att)
			local rc=rg:GetCount()
			if rc>1 then
				rg:Sub(cm[p][att]:Filter(Card.IsAttribute,nil,att))
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
				local dg=rg:Select(p,rc-1,rc-1,nil)
				sg:Merge(dg)
			end
			att=att<<1
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local att=1
		while att<(ATTRIBUTE_DARK+ATTRIBUTE_DIVINE+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_WIND) do
			cm[p][att]:Clear()
			cm[p][att]:Merge(g:Filter(Card.IsAttribute,nil,att))
			att=att<<1
		end
	end
end