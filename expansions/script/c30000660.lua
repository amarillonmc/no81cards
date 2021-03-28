--终焉邪暗 无定形的威胁者
local m=30000660
local cm=_G["c"..m]
function cm.initial_effect(c)
--matlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0_1=e0:Clone()
	e0_1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e0_1)
	local e0_2=e0:Clone()
	e0_2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e0_2)   
--SpecialSummonRule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1) 
--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDefense(0) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoGrave(g1,REASON_COST+REASON_RETURN)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	e:SetLabel(Duel.AnnounceLevel(tp,1,12,lv))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.spfilter1(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ba=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
	if chk==0 then return c:IsAbleToHand() end
	local m=0
	if ba then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		m=1
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
	e:SetLabel(m)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.SendtoHand(c,tp,REASON_EFFECT) then return end
	if m==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local tc=Duel.GetFirstMatchingCard(cm.spfilter1,tp,LOCATION_DECK,0,nil,e,tp)
		if tc then
		   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
end