--N#12 Lonesome Nightwolf
function c31012003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c31012003.batfilter)
	c:RegisterEffect(e1)
	--shadow summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1,31012003+EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c31012003.spcon)
	e2:SetOperation(c31012003.spop)
	e2:SetValue(c31012003.val)
	c:RegisterEffect(e2)
	--reset shadow
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c31012003.cost)
	e3:SetTarget(c31012003.target)
	e3:SetOperation(c31012003.operation)
	c:RegisterEffect(e3)
end

function c31012003.batfilter(e,c)
	return not c:IsSetCard(0x891)
end

function c31012003.cfilter(c)
	return c:IsCode(31012001) and c:IsFaceup()
end

function c31012003.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c31012003.cfilter,tp,LOCATION_SZONE,0,nil)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		zone=1<<aux.MZoneSequence(seq)
		if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 then
			sg:AddCard(tc)
		end
	end
	return sg
end

function c31012003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sg=c31012003.getzone(tp)
	return sg:GetCount() > 0
end

function c31012003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=c31012003.getzone(tp)
	local g=sg:Select(tp,1,1,nil)
	local seq=g:GetFirst():GetSequence()
	local zone=1<<aux.MZoneSequence(seq)
	e:SetLabel(zone)
	Duel.Overlay(c, g)
end

function c31012003.val(e,c)
	local tp=c:GetControler()
	local s=e:GetLabel()
	return 0, s
end

function c31012003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c31012003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,LOCATION_GRAVE,nil,nil) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end

function c31012003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsExtraDeckMonster() and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) then
		local gy=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,nil,nil)
		local tc=gy:Select(tp,1,1,nil):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		tc:ReplaceEffect(31012001,RESET_EVENT+RESETS_STANDARD)
		local e0=aux.EnableChangeCode(tc,31012001,LOCATION_SZONE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end