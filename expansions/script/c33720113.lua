--[[
亡命骗徒 『三带一』
Desperado Trickster - "Two Pairs"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_DESTROY|CATEGORY_RECOVER|CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
end
function s.filter(c,chk)
	return c:IsMonster() and c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and (not chk or c:IsAbleToHand())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,true) end
	if chk==0 then
		return not Duel.PlayerHasFlagEffect(tp,id) and Duel.IsExists(true,s.filter,tp,LOCATION_GRAVE,0,1,nil,false)
	end
	local g=Duel.Group(s.filter,tp,LOCATION_GRAVE,0,nil,true):Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.HintMessage(tp,HINTMSG_TARGET)
	local tg=g:Select(tp,1,#g,nil)
	Duel.SetTargetCard(tg)
	local c=e:GetHandler()
	local p,loc=c:GetResidence()
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,tg,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,c,1,p,loc)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards()
	if #g<=0 then return end
	local n=Duel.AnnounceNumberMinMax(tp,1,#g)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		for p in aux.TurnPlayers() do
			Duel.Recover(p,n*300,REASON_EFFECT,true)
		end
		Duel.RDComplete()
	else
		local tc=g:Filter(aux.Necro(nil),nil):RandomSelect(tp,1):GetFirst()
		if tc and tc:IsAbleToHand() and Duel.SearchAndCheck(tc,tp) then
			local c=e:GetHandler()
			if c:IsRelateToChain() and Duel.Destroy(c,REASON_EFFECT)>0 then
				Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
			end
		end
	end
end