--冲锋陷阵的教团骑士
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104240)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	c:SetUniqueOnField(1,1,m) 
	aux.AddXyzProcedure(c,cm.xyz,8,2)
	--Announce Sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Announce Sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.discondition)
	e2:SetTarget(cm.distarget)
	e2:SetOperation(cm.disoperation)
	c:RegisterEffect(e2)
	--cannot act or Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(cm.actlimit)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetCondition(cm.discon1)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetCondition(cm.discon2)
	e8:SetValue(cm.efilter)
	e8:SetOwnerPlayer(tp)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_ONFIELD,0)
	e9:SetCondition(cm.discon3)
	e9:SetValue(cm.efilter)
	e9:SetOwnerPlayer(tp)
	c:RegisterEffect(e9) 
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_CANNOT_SUMMON)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(0,1)
	e10:SetCondition(cm.discon4)
	e10:SetLabel(1)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e11)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,3))
	e12:SetCategory(CATEGORY_ANNOUNCE)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetCost(rscost.rmxyz(1))
	e12:SetTarget(cm.antg)
	e12:SetOperation(cm.anop)
	c:RegisterEffect(e12)
	local e13=rkch.MonzToPen(c,m,EVENT_RELEASE,nil)
	if not cm.global_check then
		cm.global_check=true
		GS_announce={}
		GS_announce[1]=0 
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	if ex then
	   GS_announce[#GS_announce+1]=ex
	end
end
function cm.is_include(value,tab)
	if tab==nil then return false end
	for k,v in ipairs(tab) do
	  if v == value then
		  return true
	  end
	end
	return false
end
function cm.xyz(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	return ex or re:GetCategory()&CATEGORY_ANNOUNCE~=0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_PZONE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
	return true
end
function cm.discondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==1 then
			return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanRemove(tp) 
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,0)
end
function cm.rmfilter(c,ac,tp)
	return c:IsAbleToRemove(1-tp,POS_FACEDOWN,REASON_EFFECT) and c:IsCode(ac)
end
function cm.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g1)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,nil,ac,1-tp)
		e:SetOwnerPlayer(tp)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
function cm.val(e,c)
	return cm.is_include(c:GetCode(),GS_announce)
end
function cm.actlimit(e,re,tp)
	return cm.is_include(re:GetHandler():GetCode(),GS_announce)
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m+100)>=1
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m+100)>=3
end
function cm.discon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m+100)>=5
end
function cm.discon4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m+100)>=8
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER,OPCODE_ISTYPE)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.anop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetOperation(cm.flagop)
	e0:SetLabel(ac)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetOperation(cm.flagop1)
	e1:SetLabel(ac)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
end
function cm.desfilter(c,code,tp)
	return c:IsCode(code) and c:IsFaceup() and c:IsControler(tp) and not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.desfilter2(c,code,tp)
	return c:IsCode(code) and c:IsControler(tp)
end
function cm.flagop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if eg:IsExists(cm.desfilter2,1,nil,code,e:GetHandlerPlayer()) and e:GetHandler():IsLocation(LOCATION_MZONE) then
		e:GetHandler():RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD,0,0,0)
	end
end
function cm.flagop1(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if eg:IsExists(cm.desfilter,1,nil,code,e:GetHandlerPlayer()) and e:GetHandler():IsLocation(LOCATION_MZONE) then
		e:GetHandler():RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD,0,0,0)  
	end
end