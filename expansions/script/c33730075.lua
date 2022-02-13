--键★高潮 蝉衣 | K.E.Y Climax - Abiti Sottili
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.indcon)
	e2:SetTarget(s.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--lp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.lptg)
	e4:SetOperation(s.lpop)
	c:RegisterEffect(e4)
end
s.wind_wb_key_monsters = true


function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Damage(tp,2000,REASON_COST)
end

function s.lvcheck(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.efilter(c,lv)
	if not c:IsLevelAbove(1) and not c:IsType(TYPE_XYZ) then return false end
	local stat=(c:IsType(TYPE_XYZ)) and c:GetRank() or c:GetLevel()
	return c:IsFaceup() and stat>lv
end
function s.indcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(s.lvcheck,tp,LOCATION_MZONE,0,nil)
	if #g<=0 then return false end
	local max=g:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
	return not Duel.IsExistingMatchingCard(s.efilter,tp,0,LOCATION_MZONE,1,nil,max)
end
function s.indtg(e,c)
	return c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINDBEAST)
end

function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end