--空想乌托邦 混沌之海
local m=10122001
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
if not rsv.Utoland then
   rsv.Utoland={}
   rsul=rsv.Utoland
function rsul.SpecialOrPlaceBool(tp,rc)
	local szone1,szone2=0,1
	if rc and rc:IsLocation(LOCATION_SZONE) then
	   szone1= rc and -1 or 0
	   szone2= rc and 0 or 1
	end
	local b1=(not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp,rc)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK))
	local b2=(Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>szone2)
	local a1=(Duel.GetMZoneCount(tp,rc)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK))
	local a2=(Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>szone1)
	local b3=(a1 and a2)
	return b1,b2,b3,a1,a2
end
function rsul.GraveDestroyActivateEffect(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122001,8))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
	e1:SetCountLimit(1,code)
	e1:SetLabel(code)
	e1:SetTarget(rsul.gdtg)
	e1:SetOperation(rsul.gdop)
	c:RegisterEffect(e1)
end
function rsul.gdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chkc then return false end
	if chk==0 then return tc and tc:IsCanBeEffectTarget(e) and e:GetHandler():GetActivateEffect():IsActivatable(tp) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_FZONE)
end
function rsul.gdop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	local te=tc:GetActivateEffect()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and te:IsActivatable(tp) then
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function rsul.ToHandActivateEffect(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122001,8))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
	e1:SetCountLimit(1,code)
	e1:SetLabel(code)
	e1:SetCost(rsul.thcost)
	e1:SetTarget(rsul.thtg)
	e1:SetOperation(rsul.thop)
	c:RegisterEffect(e1)
end
function rsul.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(rsul.thfilter,tp,LOCATION_HAND,0,1,nil,tp,e:GetLabel()) end
end
function rsul.thfilter(c,tp,code)
	if not c:IsType(TYPE_FIELD) or c:IsCode(code) then return false end
	local te=c:GetActivateEffect()
	--for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}) do
		--local con,val=pe:GetCondition(),pe:GetValue()
		--if (not con or con(pe)) and val(pe,te,1-tp) then return false --end
	--end
	--return not c:IsHasEffect(EFFECT_CANNOT_TRIGGER) and not c:IsHasEffect(EFFECT_CANNOT_ACTIVATE)
	return te:IsActivatable(tp,true)
end
function rsul.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122001,7))
	local tc=Duel.SelectMatchingCard(tp,rsul.thfilter,tp,LOCATION_HAND,0,1,1,nil,tp,e:GetLabel()):GetFirst()
	if tc then
	   local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	   if fc then
		  Duel.SendtoGrave(fc,REASON_RULE)
		  Duel.BreakEffect()
	   end
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local te=tc:GetActivateEffect()
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function rsul.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function rsul.TokenTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK)) or (Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) end
	   Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function rsul.TokenOp(op,ignore)
	return function(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	   if (not ignore and not c:IsRelateToEffect(e)) then return end
	   local b1=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK))
	   local b2=(Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	   if not b1 and not b2 then return end
	   local token=Duel.CreateToken(tp,10122011)
	   local sel=rsof.SelectOption(tp,b1,aux.Stringid(10122021,0),b2,aux.Stringid(10122021,1),true)
	   if sel==1 and Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	   if sel==2 and Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		  local e1=Effect.CreateEffect(c)
		  e1:SetCode(EFFECT_CHANGE_TYPE)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(rsreset.est-RESET_TURN_SET)
		  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		  token:RegisterEffect(e1,true)
		  rsul.TokenSpellOp(c,token)
	   else return
	   end
	   op({e:GetHandler(),token},e)
	end 
end
function rsul.TokenSpellOp(c,tc)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetReset(rsreset.est)
	e0:SetDescription(aux.Stringid(10122001,1))
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetTarget(function(e,sc)
	   return e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,tp):IsContains(sc)
	end)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(aux.indoval)
	tc:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(function(e,re,rp)
	   return rp==1-e:GetHandlerPlayer()
	end)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	tc:RegisterEffect(e2)   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetReset(rsreset.est)
	e3:SetCondition(function(e,tp)
	   return Duel.GetTurnPlayer()==tp
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp):FilterCount(Card.IsAbleToRemove,nil)>0 end
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	   local g=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToRemove,nil)  
	   if g:GetCount()>0 then
		  Duel.Hint(HINT_CARD,0,10122011)
		  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	   end  
	end)
	tc:RegisterEffect(e3)
end
-------
end
if cm then
function cm.initial_effect(c)
	rsef.ACT(c)
	rsul.ToHandActivateEffect(c,m)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(cm.tkcost)
	e1:SetTarget(rsul.TokenTg)
	e1:SetOperation(rsul.TokenOp(cm.op))
	c:RegisterEffect(e1)   
end
function cm.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.op(c,tc)
	rsef.SV_INDESTRUCTABLE(c,"battle",1,nil,rsreset.est,nil,{m,3})
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,6})
end
function cm.val1(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function cm.val2(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
------
end