--鸣霄仕卫 - 铁门栓
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9f6))
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--move/swap/negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.mvtg)
	e2:SetOperation(s.mvop)
	c:RegisterEffect(e2)
end
function s.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,nil,0x9f6)
	return g:GetClassCount(Card.GetCode)*100
end
function s.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f6)
end
function s.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function s.canmove(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function s.canswap(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	return (seq>0 and g:IsExists(s.seqfilter,1,c,seq-1))
		or (seq<4 and g:IsExists(s.seqfilter,1,c,seq+1))
end
function s.existfilter(c,tp)
	return s.mvfilter(c) and (s.canmove(c,tp) or s.canswap(c,tp))
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.existfilter(chkc,tp) end
	local chain=0
	local cur=Duel.GetReadyChain()
	if cur>0 and Duel.GetChainInfo(cur,CHAININFO_TRIGGERING_CONTROLER)==1-tp then
		chain=cur
	end
	if chk==0 then
		e:SetCategory(chain>0 and CATEGORY_DISABLE or 0)
		return Duel.IsExistingTarget(s.existfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,s.existfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local b1=s.canmove(tc,tp)
	local b2=s.canswap(tc,tp)
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=0
	else
		opt=1
	end
	if chain>0 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
	e:SetLabel(chain,opt)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	local chain,opt=e:GetLabel()
	local seq=tc:GetSequence()
	if opt==0 then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
		flag=bit.bxor(flag,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local z=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=0
		if z==1 then nseq=0
		elseif z==2 then nseq=1
		elseif z==4 then nseq=2
		elseif z==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(tc,nseq)
	else
		local g=Group.CreateGroup()
		if seq>0 then
			local sc=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,0,tc,seq-1):GetFirst()
			if sc then g:AddCard(sc) end
		end
		if seq<4 then
			local sc=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,0,tc,seq+1):GetFirst()
			if sc then g:AddCard(sc) end
		end
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.SwapSequence(tc,sc)
		end
	end
	if chain>0 then
		Duel.NegateEffect(chain)
	end
end
