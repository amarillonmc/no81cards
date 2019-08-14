--深层空想 死域之海
local m=10122015
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	rsef.ACT(c)
	rsul.GraveDestroyActivateEffect(c,m)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1)
	e2:SetCost(cm.tkcost)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)	 
end
function cm.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
	if chk==0 then 
	   if e:GetLabel()~=100 then return false end
	   return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) and (a1 or a2)
	end
	local ct=1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if b1 then
	   ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),2)
	end
	if not b1 and b2 then
	   ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),2)
	end
	if not b1 and not b2 then
	   if a1 and a2 then
		  ct=2
	   else
		  ct=1
	   end
	end
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetValue(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetValue()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
	if not a1 and not a2 then return end
	local ftm,fts=Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>1 then
	  if not b1 and not a2 then return end  
	  if not b2 and not a1 then return end
	end
	local g,sp=Group.CreateGroup(),false
	for i=1,ct do
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
		   cm.op({c,tc})
	   end
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0xc333) and c:IsAbleToRemoveAsCost()
end
function cm.op(c)
	rsef.SV_INDESTRUCTABLE(c,"ct",cm.valcon,nil,rsreset.est,nil,{m,1},1)
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,3})
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
