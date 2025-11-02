--失控磁盘协力
function c95101244.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c95101244.target)
	e1:SetOperation(c95101244.activate)
	c:RegisterEffect(e1)
end
function c95101242.tfilter(c,e)
	return c:IsSetCard(0x6bb0) and c:IsFaceup() and c:GetSequence()<=4 and c:IsCanBeEffectTarget(e)
end
function c95101244.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c95101242.cfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsPosition,POS_ATTACK,POS_DEFENSE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsPosition,POS_ATTACK,POS_DEFENSE)
	Duel.SetTargetCard(sg)
end
function c95101244.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:FilterCount(Card.IsFaceup,nil)~=2 then return end
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(95101244,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(95101244,2))
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetCondition(c95101244.discon)
	e1:SetTarget(c95101244.distg)
	e1:SetLabelObject(g)
	e1:SetLabel(fid)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101244.ffilter(c,fid)
	return c:GetFlagEffectLabel(95101244)==fid
end
function c95101244.discon(e)
	local g=e:GetLabelObject()
	return g:FilterCount(c95101244.ffilter,nil,fid)==2 and aux.gfcheck(g,Card.IsPosition,POS_ATTACK,POS_DEFENSE)
end
function c95101244.distg(e,c)
	local g=e:GetLabelObject()
	local seq1=aux.GetColumn(g:GetFirst(),e:GetHandlerPlayer())
	local seq2=aux.GetColumn(g:GetNext(),e:GetHandlerPlayer())
	if seq1>seq2 then seq1,seq2=seq2,seq1 end
	local seq=aux.GetColumn(c,e:GetHandlerPlayer())
	return seq>seq1 and seq<seq2
end
