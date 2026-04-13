--棱镜世界的故障-映照
---@diagnostic disable: unused-local, undefined-global
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),3,2,nil,nil,99)
	--①when SS: banish 2 overlay units → SS up to 2 棱镜世界 monsters from GY/banished
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--②overlay units banished by this card's effect without using XYZ materials → cost unnecessary
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--③when banished: banish 2 overlay units from own field as cost
	--(if own 棱镜世界 monster exists, cost not needed) → search 1 棱镜世界 card from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+100000)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	local e0b=e0:Clone()
	e0b:SetLabelObject(e3)
	c:RegisterEffect(e0b)
end
function s.valcheck(e,c)
	if c:GetMaterial():GetCount()==0 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--①
function s.prismfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x716) and c:IsType(TYPE_MONSTER)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabel()==1 or
		(c:GetOverlayCount()>=2 and c:GetOverlayGroup():IsExists(Card.IsAbleToRemoveAsCost,2,nil))
	end
	if e:GetLabel()~=1 then
		local g=c:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:FilterSelect(tp,Card.IsAbleToRemove,2,2,nil,POS_FACEUP)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0x716) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--③
function s.isprismonfield(tp)
	return Duel.IsExistingMatchingCard(s.prismfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.anyoverlayfilter(c,tp)
	-- any xyz on own field with overlay units that can be removed
	return c:IsControler(tp) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
		and c:GetOverlayGroup():IsExists(Card.IsAbleToRemoveAsCost,1,nil)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if s.isprismonfield(tp) then return true end
		-- need 2 overlay units total on own field
		local total=0
		local g=Duel.GetMatchingGroup(s.anyoverlayfilter,tp,LOCATION_MZONE,0,nil,tp)
		for xc in aux.Next(g) do
			total=total+xc:GetOverlayGroup():FilterCount(Card.IsAbleToRemove,nil,POS_FACEUP)
			if total>=2 then break end
		end
		return total>=2
	end
	-- if own 棱镜世界 monster exists, skip cost entirely
	if s.isprismonfield(tp) then return end
	-- collect all removable overlay units across own xyz, then select 2
	local pool=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(s.anyoverlayfilter,tp,LOCATION_MZONE,0,nil,tp)
	for xc in aux.Next(g) do
		pool:Merge(xc:GetOverlayGroup():Filter(Card.IsAbleToRemove,nil,POS_FACEUP,tp))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=pool:Select(tp,2,2,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function s.filter3(c)
	return c:IsSetCard(0x716) and c:IsAbleToHand()
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
