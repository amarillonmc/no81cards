local m=82208111
local cm=_G["c"..m]
cm.name="辉神兵装 绀碧"
function cm.initial_effect(c)  
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
  --  c:RegisterEffect(e1)  
	--cannot attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_CANNOT_ATTACK)  
	c:RegisterEffect(e2) 
	--move  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)  
	e3:SetTarget(cm.seqtg)  
	e3:SetOperation(cm.seqop)  
  --  c:RegisterEffect(e3)  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return not re:GetHandler():IsSetCard(0x29e)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
		end   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		--disable field  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD)   
		e1:SetCode(EFFECT_DISABLE_FIELD) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(cm.disop)  
		e1:SetProperty(EFFECT_FLAG_REPEAT)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)  
	end
end
function cm.disfilter(c,seq)
	return c:GetSequence()==seq or (((seq==1 and c:GetSequence()==5) or (seq==3 and c:GetSequence()==6)) and c:IsLocation(LOCATION_MZONE))
end
function cm.disop(e,tp)  
	local c=e:GetHandler()
	local zone=0x1f1f0000
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local tc=g:GetFirst()
	if g:IsExists(cm.disfilter,1,nil,0) then
		zone=zone-0x10100000
	end
	if g:IsExists(cm.disfilter,1,nil,1) then
		zone=zone-0x8080000
	end
	if g:IsExists(cm.disfilter,1,nil,2) then
		zone=zone-0x4040000
	end
	if g:IsExists(cm.disfilter,1,nil,3) then
		zone=zone-0x2020000
	end
	if g:IsExists(cm.disfilter,1,nil,4) then
		zone=zone-0x1010000
	end
	local sg=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
	end
	return zone
end  
function cm.tgfilter(c,tp) 
	if c:GetColumnGroup():IsExists(Card.IsControler,1,nil,tp) then return false end
	return c:IsAbleToGrave() and c:GetSequence()<5 
end  
function cm.seqfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x29e)  
end  
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.seqfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end  
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))  
	Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)  
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)  
	local nseq=math.log(s,2)  
	Duel.MoveSequence(tc,nseq)  
end  