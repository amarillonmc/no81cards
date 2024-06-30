--[[
动物朋友博士 加古
Kako, Anifriends' Professor
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,4,99)
	--Once per turn (Quick Effect): You can detach 1 material from this card; attach 1 banished "Anifriends" monster to this card as material, and if you do, you can place 1 monster attached to this card as material face-up on your field in Attack Position.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:OPT()
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,aux.DetachSelfCost(),s.target,s.operation)
	c:RegisterEffect(e1)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER)
end
function s.xyzcheck(g)
	local ct=g:GetClassCount(Card.GetCode)
	return g:IsExists(Card.IsSetCard,1,nil,ARCHE_ANIFRIENDS) and (ct==1 or ct==#g)
end

--E1
function s.filter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsCanOverlay(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExists(false,s.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp)
	end
end
function s.pcfilter(c,tp)
	return c:IsMonster() and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsType(TYPE_XYZ) then
		local g=Duel.Select(HINTMSG_XMATERIAL,false,tp,s.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,tp)
		if #g>0 then
			Duel.HintSelection(g)
			if Duel.Attach(g:GetFirst(),c) and c:IsRelateToChain() and c:GetOverlayGroup():IsExists(s.pcfilter,1,nil,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.HintMessage(tp,HINTMSG_TOFIELD)
				local tc=c:GetOverlayGroup():FilterSelect(tp,s.pcfilter,1,1,nil,tp):GetFirst()
				if tc then
					Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
				end
			end
		end
	end
end