--[[
花花变身·动物朋友 玄武
H-Anifriends Genbu
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2,s.altmat,aux.Stringid(id,0),s.altop)
	--This card's name becomes "Anifriends Genbu of the North" while on the field or in the GY.
	aux.EnableChangeCode(c,33700084,LOCATION_MZONE|LOCATION_GRAVE)
	--While your opponent has both cards with the same name and cards with different names in their GY, this card is unaffected by your opponent's card effects, also it cannot be destroyed by battle.
	c:Unaffected(UNAFFECTED_OPPO,s.econd)
	c:CannotBeDestroyedByBattle(1,s.econd)
	--You can detach 1 material from this card; shuffle, from your hand and/or field, 3 or more monsters with different names or with the same name, and if you do, draw that many cards and reveal them, then you must discard some of them so that each of those cards either have different names or have the same name.
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_DRAW|CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:HOPT()
	e1:SetFunctions(nil,aux.DetachSelfCost(),s.target,s.operation)
	c:RegisterEffect(e1)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,4)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)+g:GetClassCount(Card.GetRace)==2
end
function s.altmat(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_ANIFRIENDS) and not c:IsCode(id) and c:IsSpecialSummoned()
end
function s.altop(e,tp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
end

--E0
function s.econd(e)
	local p=1-e:GetHandlerPlayer()
	local g=Duel.GetGY(p)
	return g:CheckSubGroup(aux.dncheck,2,2) and g:CheckSubGroup(aux.sncheck,2,2)
end

--E1
function s.gcheck0(g)
	local ct=g:GetClassCount(Card.GetCode)
	return ct==1 or ct==#g
end
function s.gcheck(g,_,tp,mg,c)
	local ct=g:GetClassCount(Card.GetCode)
	local res=(ct==1 or ct==#g) and Duel.IsPlayerCanDraw(tp,#g)
	return res, ((ct>1 and ct~=#g) or not Duel.IsPlayerCanDraw(tp,#g))
end
function s.rescon(g,e,tp)
	return s.gcheck0(g) and Duel.IsPlayerCanDraw(tp,#g)
end
function s.breakcon(g,e,tp,mg)
	return Duel.IsPlayerCanDraw(tp,#g) and not Duel.IsPlayerCanDraw(tp,#g+1)
end
function s.tdfilter(c)
	if not (c:IsFaceupEx() and c:IsAbleToDeck()) then return false end
	return c:IsLocation(LOCATION_MZONE) or c:IsMonster()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.Group(s.tdfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil)
	if chk==0 then
		return aux.SelectUnselectGroup(g,e,tp,3,#g,s.gcheck,0)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_HAND|LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.tdfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil)
	local tg=aux.SelectUnselectGroup(g,e,tp,3,#g,s.gcheck,1,tp,HINTMSG_TODECK,s.rescon,s.breakcon)
	if #tg>0 then
		Duel.HintSelection(tg:Filter(Card.IsOnField,nil))
		Duel.ConfirmCards(1-tp,tg:Filter(Card.IsLocation,nil,LOCATION_HAND))
		local ct=Duel.ShuffleIntoDeck(tg)
		if ct>=3 then
			local p=Duel.GetTargetPlayer()
			if Duel.Draw(p,ct,REASON_EFFECT)>0 then
				local og=Duel.GetOperatedGroup()
				Duel.ConfirmCards(1-p,og)
				local ct2=og:GetClassCount(Card.GetCode)
				if ct2>1 and ct2~=#og then
					local dg=aux.SelectUnselectGroup(og,e,tp,1,#g-1,s.gcheck0,1,tp,HINTMSG_DISCARD,s.gcheck0)
					if #dg>0 then
						Duel.BreakEffect()
						Duel.SendtoGrave(dg,REASON_EFFECT|REASON_DISCARD)
					end
				end
				Duel.ShuffleHand(p)
			end
		end
	end
end