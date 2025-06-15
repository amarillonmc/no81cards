--[[
动物朋友 白龙马
Anifriends Gyokuryu
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,CARD_RESURGENCE_OF_THE_SANDSTAR)
	--3+ monsters with different names
	aux.AddXyzProcedureLevelFree(c,s.matfilter,s.xyzcheck,3,99)
	--If this card is Special Summoned: Send 1 "Resurgence of the Sandstar" from your hand or Deck to the GY, OR send all cards you control to the GY, then gain 1000 LP for each card sent to the GY this way.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.tgtg,s.tgop)
	c:RegisterEffect(e1)
	--(Quick Effect): You can target 1 other monster on the field; attach that target to this card as material.
	local e2=Effect.CreateEffect(c)
	e2:Desc(3,id)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetRelevantTimings()
	e2:SetFunctions(nil,aux.DummyCost,s.target,s.operation)
	c:RegisterEffect(e2)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end

--E1
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.Group(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,#g*1000)
end
function s.tgfilter(c)
	return c:IsCode(CARD_RESURGENCE_OF_THE_SANDSTAR) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
	local b1=Duel.IsExists(false,s.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil)
	local b2=#g>0
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,id,1,b1,b2)
	if opt==0 then
		local tg=Duel.Select(HINTMSG_TOGRAVE,false,tp,s.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	elseif opt==1 then
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			local ct=Duel.GetGroupOperatedByThisEffect(e):FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if ct>0 then
				Duel.BreakEffect()
				Duel.Recover(tp,ct*1000,REASON_EFFECT)
			end
		end
	end
end

--E2
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local exc=chk==0 and c or aux.ExceptThis(c,e)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=aux.ExceptThis(c,e) and chkc:IsCanBeAttachedTo(c,e) end
	local ct=c:GetOverlayCount()
	local b1=Duel.IsExists(true,Card.IsCanBeAttachedTo,tp,LOCATION_MZONE,LOCATION_MZONE,1,exc,c,e) and not Duel.PlayerHasFlagEffectLabel(tp,id,0)
	local b2=e:IsCostChecked() and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) and c:GetOverlayGroup():IsExists(Card.IsDefenseAbove,1,nil,1) and not Duel.PlayerHasFlagEffectLabel(tp,id,1)
	if chk==0 then
		return b1 or b2
	end
	local opt=aux.Option(tp,id,4,b1,b2)
	local flag,lab
	if opt==0 then
		flag,lab=id,0
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Select(HINTMSG_TARGET,true,tp,Card.IsCanBeAttachedTo,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,exc,c,e)
	elseif opt==1 then
		flag,lab=id+100,1
		e:SetCategory(CATEGORY_RECOVER)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
		local g=Duel.GetGroupOperatedByThisCost(e):Filter(Card.IsDefenseAbove,nil,1)
		local val=g:GetSum(Card.GetDefense)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(val)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1,lab)
	c:RegisterFlagEffect(flag,RESET_CHAIN,0,1,Duel.GetCurrentChain())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ch=Duel.GetCurrentChain()
	if c:HasFlagEffectLabel(id,ch) then
		local tc=Duel.GetFirstTarget()
		if c:IsRelateToChain() and tc:IsRelateToChain() and tc~=c then
			Duel.Attach(tc,c,fale,e,REASON_EFFECT,tp)
		end
	elseif c:HasFlagEffectLabel(id+100,ch) then
		local val=Duel.GetTargetParam()
		Duel.Recover(tp,val,REASON_EFFECT)
	end
end