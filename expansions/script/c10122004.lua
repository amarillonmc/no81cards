--空想星界 星辉沼地
local m=10122004
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	rsef.ACT(c)
	rsul.ToHandActivateEffect(c,m)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(cm.tkcost)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)  
end
function cm.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.rfilter(c)
	return c:IsCode(10122011) and c:IsReleasable()
end
function cm.cfilter(c,tp)
	local b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp,c)
	return b1 or b2 or b3
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil)
	local g2=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_SZONE,0,nil)
	g1:Merge(g2)
	if chk==0 then 
	   if e:GetLabel()==1 then
		  e:SetLabel(0)
		  return g1:IsExists(cm.cfilter,1,nil,tp)
	   else
		  local b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
		  return b1 or b2 or b3
	   end
	end
	if e:GetLabel()==1 then
	   e:SetLabel(0)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local rg=g1:FilterSelect(tp,cm.cfilter,1,1,nil,tp)
	   Duel.Release(rg,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
	if not b1 and not b2 and not b3 then return end
	local g,sp=Group.CreateGroup(),false
	for i=1,2 do
		b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
		local token=Duel.CreateToken(tp,10122011)
		if (not Duel.IsPlayerAffectedByEffect(tp,59822133) or not sp) and (a1 and (not a2 or not Duel.SelectYesNo(tp,aux.Stringid(10122021,0)))) then
		   if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			  sp=true
			  g:AddCard(token)
		   end
		else
		   if Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			  local e1=Effect.CreateEffect(c)
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+0x1fc0000)
			  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			  token:RegisterEffect(e1,true)
			  g:AddCard(token)
			  rsul.TokenSpellOp(c,token)
		   end
		end
	end
	if sp then Duel.SpecialSummonComplete() end
	if g:GetCount()>0 then
	   for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetDescription(aux.Stringid(m,6))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetDescription(aux.Stringid(10122004,3))
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		end
	end
end
