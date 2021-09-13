--飓风之观测者 万由里
local m=33401603
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
XY.mayuri(c)
	 --sps
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,0))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,m+10000)
	e8:SetCondition(cm.con)
	e8:SetTarget(cm.sptg)
	e8:SetOperation(cm.spop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,0))
	e10:SetCategory(CATEGORY_TOHAND)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1,m+10000)
	e10:SetCondition(cm.con2)
	e10:SetTarget(cm.sptg)
	e10:SetOperation(cm.spop)
	c:RegisterEffect(e10)
end
function cm.cfilter(c,tp)
	return  c:IsFaceup() and c:IsSetCard(0x6344) and c:IsControler(tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.thfilter(c)
	return c:IsSetCard(0x6344) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.cfilter2(c)
	return  c:IsType(TYPE_FUSION) and c:IsFaceup() and not c:IsSetCard(0x6344) and c:IsControler(tp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter2,1,nil) 
end
function cm.thfilter1(c)
	return  c:IsSetCard(0x6344) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.filter(c,g)
	return g:IsContains(c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and  Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then   
		   local cg=e:GetHandler():GetColumnGroup()
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		 local g2=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
		 Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end







