--五河士道 暴走形态
function c33401309.initial_effect(c)
	aux.AddFusionProcFunFunRep(c,c33401309.matfilter1,c33401309.matfilter,2,2,true)
	c:SetUniqueOnField(1,0,33401309)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33401309,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33401309)
	e1:SetTarget(c33401309.thtg2)
	e1:SetOperation(c33401309.thop2)
	c:RegisterEffect(e1)
  --copy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetDescription(aux.Stringid(33401309,2))
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,33401309+10000)
	e6:SetTarget(c33401309.cptg)
	e6:SetOperation(c33401309.cpop)
	c:RegisterEffect(e6)
end
function c33401309.matfilter1(c)
	return  c:IsSetCard(0x341) and c:IsFusionType(TYPE_FUSION) or c:IsFusionType(TYPE_SYNCHRO) or c:IsFusionType(TYPE_XYZ)
end
function c33401309.matfilter(c)
	return c:IsSetCard(0x341)
end

function c33401309.thfilter2(c)
	return c:IsSetCard(0x340)  and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden()
end
function c33401309.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33401309.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c33401309.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33401309,0))
	local g=Duel.SelectMatchingCard(tp,c33401309.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if #g>0 then
		 Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	end
end

function c33401309.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c33401309.matfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c33401309.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c33401309.matfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local code=cg:GetFirst():GetOriginalCode()
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	c:RegisterFlagEffect(33401301,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
end