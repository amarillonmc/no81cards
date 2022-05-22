local m=31400053
local cm=_G["c"..m]
local s,id,o=GetID()
cm.name="恐吓爪牙族·维萨斯=星霜"
function cm.initial_effect(c)
	aux.EnableChangeCode(c,56099748)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.hspcon)
	e1:SetValue(s.hspval)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x17a)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.damtg)
	e3:SetValue(cm.damvalue)
	c:RegisterEffect(e3)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(cm.linklimit)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function cm.linklimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x17a)
end
function s.cfilter(c)
	return c:IsSetCard(0x17a) and c:IsFaceup()
end
function s.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	return zone
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=s.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function s.hspval(e,c)
	local tp=c:GetControler()
	return 0,s.getzone(tp)
end
function cm.damtg(e,c)
	return c:IsSetCard(0x17a) and c:GetSequence()>=5
end
function cm.deffilter(c)
	return c:IsDefensePos() and c:IsSetCard(0x17a) and c:IsFaceup()
end
function cm.damvalue(e,damp)
	local dam=Duel.GetBattleDamage(damp)
	local num=Duel.GetMatchingGroup(cm.deffilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)
	if num<1 then num=1 end
	return dam*num
end