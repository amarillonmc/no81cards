--深层空想 燃魂沙丘
local m=10122016
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
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)
	if cm.counter==nil then
	   cm.counter=true
	   cm[0]=0
	   cm[1]=0
	   local ge1=Effect.CreateEffect(c)
	   ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   ge1:SetCode(EVENT_CHAINING)
	   ge1:SetOperation(cm.ctop)
	   Duel.RegisterEffect(ge1,0)
	   local ge2=ge1:Clone()
	   ge2:SetCode(EVENT_CHAIN_NEGATED)
	   ge2:SetOperation(cm.ctop2)
	   Duel.RegisterEffect(ge2,0)
	   local ge3=ge1:Clone()
	   ge3:SetCode(4179255)
	   ge3:SetOperation(cm.ctop)
	   Duel.RegisterEffect(ge3,0)
	   local ge4=ge1:Clone()
	   ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	   ge4:SetOperation(cm.ctop3)
	   Duel.RegisterEffect(ge4,0)
	end
end
function cm.ctop3(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:GetHandler():IsType(TYPE_FIELD) then return end
	cm[rp]=cm[rp]+1
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:GetHandler():IsType(TYPE_FIELD) then return end
	cm[rp]=cm[rp]-1
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
	if chk==0 then return (a1 or a2) and cm[tp]>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
	if not a1 and not a2 then return end
	local ftm,fts=0,0
	if a1 then
	   ftm=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetLocationCount(tp,LOCATION_MZONE)
	end
	if a2 then
	   fts=Duel.GetLocationCount(tp,LOCATION_SZONE)
	end
	local ft=ftm+fts
	local ct=math.min(ft,cm[tp])
	local g,sp=Group.CreateGroup(),false
	for i=1,ct do
		b1,b2,b3,a1,a2=rsul.SpecialOrPlaceBool(tp)
		if i>1 and not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then break end
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
function cm.op(c)
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,3})
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
