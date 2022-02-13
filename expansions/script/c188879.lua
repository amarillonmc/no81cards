local m=188879
local cm=_G["c"..m]
cm.name="星魅的灼焰之臂-艾登"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+100)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	local seq=c:GetSequence()
	return seq<5 and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)))
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local seq=g:GetFirst():GetSequence()
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(g:GetFirst(),nseq)
	if not c:IsLocation(LOCATION_GRAVE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1,true)
end
function cm.thfilter(c)
	return c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca2)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(cm.mvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			local sg=Duel.SelectMatchingCard(tp,cm.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(sg:GetFirst(),nseq)
		end
	end
end
