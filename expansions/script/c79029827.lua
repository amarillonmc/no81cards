--构造终解 幻想鸣奏
function c79029827.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetOperation(c79029827.activate)
	c:RegisterEffect(e1)	
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2) 
	--place card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029827,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCountLimit(1)
	e3:SetLabel(79029827)
	e3:SetCondition(c79029827.plcon)
	e3:SetTarget(c79029827.pltg)
	e3:SetOperation(c79029827.plop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c79029827.incon)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(c79029827.intg)
	e4:SetValue(c79029827.indesval)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e5)
end
function c79029827.spfilter(c,e,tp)
	return c:IsSetCard(0xa991) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029827.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029827.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(79029827,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029827.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029827.splimit(e,c)
	return not c:IsSetCard(0xa991) and c:IsLocation(LOCATION_EXTRA)
end
function c79029827.incon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029823)
end
function c79029827.intg(e,c)
	return c:IsCode(79029827,79029831,79029832,79029833,79029834,79029835)
end
function c79029827.indesval(e,re,r,rp)
	return bit.band(r,REASON_RULE)==0
end
function c79029827.plcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029827)<5 
end
function c79029827.ckfil(c,tp)
	local seq=c:GetSequence()
	return c:IsCode(79029823,79029825) and (Duel.CheckLocation(tp,LOCATION_SZONE,seq) or Duel.CheckLocation(1-tp,LOCATION_SZONE,4-seq))
end
function c79029827.pltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c79029827.ckfil,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SelectTarget(tp,c79029827.ckfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
end 
function c79029827.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	local seq=tc:GetSequence()
	if not Duel.CheckLocation(tp,LOCATION_SZONE,seq) and not Duel.CheckLocation(1-tp,LOCATION_SZONE,4-seq) then return end 
	c:RegisterFlagEffect(79029827,RESET_EVENT+RESETS_STANDARD,0,1) 
	local x=c:GetFlagEffect(79029827) 
	local code=0
	if x==1 then code=79029831 
	elseif x==2 then code=79029832 
	elseif x==3 then code=79029833 
	elseif x==4 then code=79029834 
	elseif x==5 then code=79029835 
	end
	local token=Duel.CreateToken(tp,code)
	local op=0 
	if Duel.CheckLocation(tp,LOCATION_SZONE,seq) and Duel.CheckLocation(1-tp,LOCATION_SZONE,4-seq) then 
	op=Duel.SelectOption(tp,aux.Stringid(79029827,1),aux.Stringid(79029827,2))
	elseif Duel.CheckLocation(tp,LOCATION_SZONE,seq) then 
	op=Duel.SelectOption(tp,aux.Stringid(79029827,1))
	elseif Duel.CheckLocation(1-tp,LOCATION_SZONE,4-seq) then 
	op=Duel.SelectOption(tp,aux.Stringid(79029827,2))+1   
	end
	if op==0 then 
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.MoveSequence(token,seq) 
	else 
	p=1-tp 
	Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.MoveSequence(token,4-seq) 
	end
	local xc=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,LOCATION_MZONE,0,nil,79029823):GetFirst()
	Duel.HintSelection(Group.FromCards(xc))
	Duel.HintSelection(Group.FromCards(token))
	local nseq=xc:GetSequence()
	if nseq==5 then nseq=1 end 
	if nseq==6 then nseq=3 end
	if token:IsControler(tp) then 
	if nseq==seq then 
	xc:SetCardData(CARDDATA_LINK_MARKER,xc:GetLinkMarker()+LINK_MARKER_BOTTOM) 
	elseif nseq>seq then 
	xc:SetCardData(CARDDATA_LINK_MARKER,xc:GetLinkMarker()+LINK_MARKER_BOTTOM_LEFT) 
	elseif nseq<seq then 
	xc:SetCardData(CARDDATA_LINK_MARKER,xc:GetLinkMarker()+LINK_MARKER_BOTTOM_RIGHT) 
	end
	else 
	if nseq==4-seq then 
	xc:SetCardData(CARDDATA_LINK_MARKER,xc:GetLinkMarker()+LINK_MARKER_TOP) 
	elseif nseq>4-seq then 
	xc:SetCardData(CARDDATA_LINK_MARKER,xc:GetLinkMarker()+LINK_MARKER_TOP_LEFT) 
	elseif nseq<4-seq then 
	xc:SetCardData(CARDDATA_LINK_MARKER,xc:GetLinkMarker()+LINK_MARKER_TOP_RIGHT) 
	end	
	end
	end
end



