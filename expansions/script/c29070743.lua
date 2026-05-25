--方舟骑士-W
local cm,m=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--aux.AddCodeList(c,29065500)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--skill
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.spcfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(Card.IsDiscardable, tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g=Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_EFFECT, nil, REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	local flag=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	local seq=math.log(flag,2)
	if tp==0 then
		seq=20-seq
	else
		seq=4-seq
	end
	e:SetLabel(seq)
	Duel.Hint(HINT_ZONE,tp,flag)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	Debug.Message(seq)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_MOVE)
	e1:SetLabel(seq)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
function cm.fdcheck(c,tp,seq)
	if not c:IsOnField() then return false end
	if not c:IsControler(1-tp) then return false end
	local col=aux.GetColumn(c, tp)
	if col==5 then
		return col == 5 and seq==1
	elseif col==6 then
		return col == 6 and seq==3
	else
		return (math.abs(col - seq)==1 and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5) or seq==col
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local fg=eg:Filter(cm.fdcheck,nil,tp,e:GetLabel())
	return fg and fg:GetCount()>0
end
function cm.desfilter(c,p,loc,seq)
	local seq1=c:GetSequence()
	return aux.GetColumn(c,p)==seq or (c:IsControler(p) and c:IsLocation(loc) and math.abs(seq1-seq)==1 and seq<5 and seq1<5)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.fdcheck,tp,0,LOCATION_ONFIELD,nil,tp,e:GetLabel())
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	e:Reset()
end