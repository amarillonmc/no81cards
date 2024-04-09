--凶器灵·混沌虚空琴
function c60153208.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunRep(c,c60153208.mfilter,2,true)
	--spsum condition
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--splimit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(c60153208.splimit)
	c:RegisterEffect(e11)
	
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60153208,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c60153208.e1tg)
	e1:SetOperation(c60153208.e1op)
	c:RegisterEffect(e1)
	
	--3
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60153208,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c60153208.e2cost)
	e2:SetOperation(c60153208.e2op)
	c:RegisterEffect(e2)
	
	--cannot material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c60153208.fuslimit)
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

function c60153208.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c60153208.mfilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3b2a) and (not sg or not sg:IsExists(Card.IsCode,1,c,c:GetCode()))
end
function c60153208.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end

function c60153208.e1tgf(c)
	return c:IsSetCard(0x3b2a) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsFaceup()
end
function c60153208.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c60153208.e1tgf(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c60153208.e1tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c60153208.e1tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60153208.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e11:SetCode(EFFECT_EQUIP_LIMIT)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD)
		e11:SetValue(c60153208.eqlimit)
		tc:RegisterEffect(e11)
		local atk=math.ceil(tc:GetBaseAttack()/2)
		if atk>0 then
			local e22=Effect.CreateEffect(c)
			e22:SetType(EFFECT_TYPE_EQUIP)
			e22:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e22:SetCode(EFFECT_UPDATE_ATTACK)
			e22:SetReset(RESET_EVENT+RESETS_STANDARD)
			e22:SetValue(atk)
			tc:RegisterEffect(e22)
		end
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
		e2:SetDescription(aux.Stringid(60153208,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c60153208.rstcon)
		e2:SetOperation(c60153208.rstop)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
		tc:RegisterFlagEffect(60153208,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c60153208.eqlimit(e,c)
	return e:GetOwner()==c
end
function c60153208.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	return Duel.GetTurnPlayer()~=e1:GetLabel()
end
function c60153208.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c60153208.e2costf(c,tp)
	return c:GetFlagEffect(60153208)~=0 and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
end
function c60153208.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	if chk==0 then return eqg:IsExists(c60153208.e2costf,1,nil,tp) and c:GetFlagEffect(60153208)==0 end
	c:RegisterFlagEffect(60153208,RESET_CHAIN,0,1)
end
function c60153208.e2opf(c,tp)
	return c:IsControler(1-tp)
end
function c60153208.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	if eqg:GetCount()>0 then
		local g=eqg:FilterSelect(tp,c60153208.e2costf,1,1,nil,tp)
		local tc=g:GetFirst()
		local g2=tc:GetColumnGroup()
		local g3=g2:Filter(c60153208.e2opf,nil,tp)
		Duel.SendtoGrave(tc,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoGrave(g3,REASON_RULE)
	end
end