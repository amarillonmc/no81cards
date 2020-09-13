--天使-飓风骑士-贯穿者
local m=33400850
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
cm.dfc_front_side=33400850
cm.dfc_back_side=33400852
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.mvtg)
	e2:SetOperation(cm.mvop)
	c:RegisterEffect(e2)
 --actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.actcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(cm.cfilter))
	e4:SetCondition(cm.actcon)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.ntdcon)
	e5:SetTarget(cm.ntdtg)
	e5:SetOperation(cm.ntdop)
	c:RegisterEffect(e5)	
end
function cm.mvfilter1(c)
	return c:IsFaceup() 
end
function cm.mvfilter2(c,tp)
	return c:IsFaceup()  and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(cm.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function cm.mvfilter3(c)
	return c:IsFaceup()  and c:GetSequence()<5
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
 local b1=Duel.IsExistingMatchingCard(cm.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local b2=Duel.IsExistingMatchingCard(cm.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
local b1=Duel.IsExistingMatchingCard(cm.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local b2=Duel.IsExistingMatchingCard(cm.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
  if not (b1 or b2)  then return end 
  if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
   if op==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local g=Duel.SelectMatchingCard(tp,cm.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(g:GetFirst(),nseq)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local g1=Duel.SelectMatchingCard(tp,cm.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.HintSelection(g1)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local g2=Duel.SelectMatchingCard(tp,cm.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc1,tc2)
	end
end

function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa341) and c:IsControler(tp)
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and d then 
		local seq1=aux.MZoneSequence(a:GetSequence())
		local seq2=aux.MZoneSequence(d:GetSequence())
		return ((a and cm.cfilter(a,tp)) or (d and cm.cfilter(d,tp)))and seq1==4-seq2
	end
	return false
end

function cm.cfilter2(c)
	return c:IsFaceup() and c:IsCode(33400851) and c:IsAbleToGrave()
end
function cm.ntdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.ntdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 33400852 and 33400850==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.ntdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) or not Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD,0,1,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then 
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	c:RegisterFlagEffect(33400850,0,0,0) 
	end 
end


