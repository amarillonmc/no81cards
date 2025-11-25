--幻叙探索者 Neko
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
	if c:IsOriginalCodeRule(id) and KOISHI_CHECK then		
		local tp=0 
		if Duel.GetFieldGroupCount(0,0,LOCATION_DECK)>0 or Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)>0 then tp=1 end
		local pname=s.getplayername(tp)
		local lv=Duel.GetRegistryValue("pname")
		if lv then
			s.setlv(c,lv)
		else
			Duel.SetRegistryValue("pname",1)
			s.setlv(c,1)
		end
	end
	--Change Name
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.nmcon)
	e1:SetOperation(s.nmop)
	c:RegisterEffect(e1)
	--ATK/DEF Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.thcon)
	e4:SetCost(s.thcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(s.thcon2)
	c:RegisterEffect(e5)
end
function s.getplayername(tp)
	local p0=Duel.GetRegistryValue("player_name_0")
	local p1=Duel.GetRegistryValue("player_name_1")
	if p0==p1 then
		p1=p1.."_2"
		Duel.SetRegistryValue("player_name_1",p1)
	end
	local pname="Neko_Level_Count_"
	if Duel.GetRegistryValue("player_type_0")==tp then
		pname=pname..p0
	else
		pname=pname..p1
	end
	return pname
end
function s.setlv(c,lv)
	if aux.GetValueType(lv)=="string" then lv=tonumber(lv) end
	c:SetCardData(CARDDATA_LEVEL,lv)
	if lv==1 or lv==2 then c:SetCardData(CARDDATA_CODE,id) end
	if lv==3 or lv==4 then c:SetCardData(CARDDATA_CODE,id+1) end
	if lv>=5 then c:SetCardData(CARDDATA_CODE,id+2) end
end
function s.nmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsFaceup() and rc:IsOnField() and rc:IsRelateToEffect(re) and rc:GetOriginalCode()~=id 
end
function s.nmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(id)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
end
function s.val(e,c)
	return c:GetLevel()*200
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>c:GetLevel()
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=c:GetLevel()
end
function s.costfilter(c,tp)
	return c:IsSetCard(0x838) and c:IsReleasable() and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.cfilter(c,tp)
	return c:IsOriginalCodeRule(id) and c:GetOwner()==tp
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if KOISHI_CHECK then
		local pname=s.getplayername(tp)
		local lv=Duel.GetRegistryValue("pname")
		if lv then
			lv=lv+1
			Duel.SetRegistryValue("pname",lv)	 
		else
			Duel.SetRegistryValue("pname",1)
		end
		local g=Duel.GetFieldGroup(0,0x7f,0x7f)
		local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
		g:Merge(xg)
		g=g:Filter(s.cfilter,nil,tp)
		for tc in aux.Next(g) do
			s.setlv(c,lv)
		end
	else
		local g=Duel.GetFieldGroup(0,0x7f,0x7f)
		local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
		g:Merge(xg)
		g=g:Filter(s.cfilter,nil,tp)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
	end
end