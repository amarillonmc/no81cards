--[[
同步切断
Desync
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When a Synchro Monster activates its effect on the field: Send from your Deck to the GY, 1 Tuner and 1+ non-Tuner monsters whose combined Levels equal the Level of that Synchro Monster;
	negate that effect, and if you do, destroy that monster.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DISABLE|CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetFunctions(s.condition,s.cost,s.target,s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc or not rc:IsType(TYPE_SYNCHRO) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and Duel.IsChainDisablable(ev)
end
function s.cfilter(c,lv)
	return c:IsMonster() and c:HasLevel() and not c:IsLevelAbove(lv) and c:IsAbleToGraveAsCost()
end
function s.rescon(lv)
	local lvplus=lv+1
	return	function(g,e,tp,mg,c)
				return g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER) and g:CheckWithSumEqual(Card.GetLevel,lv,#g,#g), g:CheckWithSumGreater(Card.GetLevel,lvplus)
			end
end
function s.breakcon(lv)
	return	function(g,e,tp,mg)
				return g:CheckWithSumEqual(Card.GetLevel,lv,#g,#g)
			end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local lv=rc:GetLevel()
	local g=Duel.Group(s.cfilter,tp,LOCATION_DECK,0,nil,lv)
	if chk==0 then
		return lv>0 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER) and aux.SelectUnselectGroup(g,e,tp,2,#g,s.rescon(lv),0)
	end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#g,s.rescon(lv),1,tp,HINTMSG_TOGRAVE,s.rescon(lv),s.breakcon(lv))
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_COST)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToChain(ev) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToChain(ev) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end