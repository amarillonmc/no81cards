--骑士药剂师 罗
local m=11631028
local cm=_G["c"..m]
--strings
function cm.initial_effect(c)
	--draw  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)	  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2) 
	--activate from hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTarget(cm.actfilter)  
	e4:SetTargetRange(LOCATION_HAND,0)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e5) 
end
--draw
function cm.filter(c)  
	return c:IsSetCard(0xc220) and c:IsSummonable(true,nil)
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil)  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Summon(tp,tc,true,nil)
	end  
end  
--destroy replace
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and (c:IsSetCard(0x3221) or c:IsSetCard(0xc220) )  and not c:IsReason(REASON_REPLACE) --and c:IsReason(REASON_DESTROY)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,c,tp) and c:IsAbleToRemove()
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
--act in hand
function cm.actfilter(e,c)
	return c:IsSetCard(0x5221) and c:IsPublic()
end