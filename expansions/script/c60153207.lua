--魂器灵·时空永恒钟
function c60153207.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunRep(c,c60153207.mfilter,2,true)
	--spsum condition
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--splimit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(c60153207.splimit)
	c:RegisterEffect(e11)
	
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60153207,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c60153207.e1tg)
	e1:SetOperation(c60153207.e1op)
	c:RegisterEffect(e1)
	
	--2
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(60153207,1))
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCondition(c60153207.indcon)
	e22:SetValue(1)
	c:RegisterEffect(e22)
	local e33=e22:Clone()
	e33:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e33)
	
	--3
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60153207,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c60153207.e2cost)
	e2:SetOperation(c60153207.e2op)
	c:RegisterEffect(e2)
	
	
	--cannot material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c60153207.fuslimit)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e8)
end

function c60153207.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c60153207.mfilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3b2a) and (not sg or not sg:IsExists(Card.IsCode,1,c,c:GetCode()))
end
function c60153207.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end

function c60153207.e1tgf(c)
	return c:IsSetCard(0x3b2a) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c60153207.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c60153207.e1tgf(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c60153207.e1tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c60153207.e1tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60153207.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e11:SetCode(EFFECT_EQUIP_LIMIT)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD)
		e11:SetValue(c60153207.eqlimit)
		tc:RegisterEffect(e11)
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetLabel(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(60153207,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c60153207.rstcon)
		e2:SetOperation(c60153207.rstop)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
		tc:RegisterFlagEffect(60153207,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c60153207.eqlimit(e,c)
	return e:GetOwner()==c
end
function c60153207.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	return Duel.GetTurnPlayer()~=e1:GetLabel()
end
function c60153207.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c60153207.indcon(e)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x3b2a)
end
function c60153207.e2costf(c,tp)
	return c:GetFlagEffect(60153207)~=0 and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
end
function c60153207.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	if chk==0 then return eqg:IsExists(c60153207.e2costf,1,nil,tp) and c:GetFlagEffect(60153207)==0 end
	c:RegisterFlagEffect(60153207,RESET_CHAIN,0,1)
end
function c60153207.e2opf(c,tp)
	return c:IsControler(1-tp)
end
function c60153207.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	if eqg:GetCount()>0 then
		local g=eqg:FilterSelect(tp,c60153207.e2costf,1,1,nil,tp)
		local tc=g:GetFirst()
		local g2=tc:GetColumnGroup()
		local g3=g2:Filter(c60153207.e2opf,nil,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetTargetRange(0,LOCATION_ONFIELD)
		e4:SetTarget(c60153207.distg)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetLabel(tc:GetSequence(),tc:GetFieldID())
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAIN_SOLVING)
		e5:SetOperation(c60153207.disop)
		e5:SetReset(RESET_PHASE+PHASE_END)
		e5:SetLabel(tc:GetSequence())
		Duel.RegisterEffect(e5,tp)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e6:SetTargetRange(0,LOCATION_ONFIELD)
		e6:SetTarget(c60153207.distg)
		e6:SetReset(RESET_PHASE+PHASE_END)
		e6:SetLabel(tc:GetSequence())
		Duel.RegisterEffect(e6,tp)
		Duel.Hint(HINT_ZONE,tp,0x1<<(tc:GetSequence()+8))
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c60153207.distg(e,c)
	local seq,fid=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return aux.GetColumn(c,tp)==seq and c:GetFieldID()~=fid
end
function c60153207.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_ONFIELD~=0 and seq<=4 and (rp==1-tp and seq==4-tseq) then
		Duel.NegateEffect(ev)
	end
end