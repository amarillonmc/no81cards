--键★断片 -  观铃·翼 / Frammenti K.E.Y - Misuzu -ALA-
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCost(s.lvcost)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.incon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--cost
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.incon)
	e4:SetOperation(s.mtop)
	c:RegisterEffect(e4)
end
s.wind_wb_key_monsters = true

function s.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Damage(tp,500,REASON_COST)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLevelAbove(1) and e:GetHandler():IsLevelBelow(11) end
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsLevelAbove(1) and c:IsLevelBelow(11) and c:IsRelateToEffect(e) then
		local val=math.min(12,c:GetLevel()*2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

function s.incon(e)
	return e:GetHandler():IsLevel(12)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINDBEAST) and not c:IsPublic()
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
	local select
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if #b1>0 then
		select=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	else
		select=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
	if select==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=b1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Damage(tp,2000,REASON_COST)
	end
end