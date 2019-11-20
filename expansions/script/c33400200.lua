--天使-嗫告篇帙
function c33400200.initial_effect(c)
	 c:SetUniqueOnField(1,0,33400200)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --check 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400200,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(c33400200.cktg)
	e3:SetCondition(c33400200.condition)
	e3:SetOperation(c33400200.ckop)
	c:RegisterEffect(e3)
	 --future record
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400200,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetCondition(c33400200.condition)
	e4:SetTarget(c33400200.frtg)
	e4:SetOperation(c33400200.frop)
	c:RegisterEffect(e4)
end
function c33400200.cnfilter(c)
	return c:IsSetCard(0x6342) and not c:IsCode(33400200)
end
function c33400200.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400200.cnfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end
function c33400200.cktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0  end
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return b1 or b2 end
	local op
	if b1 and b2 then 
			 op=Duel.SelectOption(tp,aux.Stringid(33400200,1),aux.Stringid(33400200,2))
			 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(33400200,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	else
		op=Duel.SelectOption(tp,aux.Stringid(33400200,2))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	end
	e:SetLabel(op)
end
function c33400200.ckop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if cm1>2 then cm1=2 end
	if cm2>2 then cm2=2 end
	if op==0 then
		local g=Duel.GetDecktopGroup(tp,cm1)
		Duel.ConfirmCards(tp,g)  
		Duel.SortDecktop(tp,tp,cm1)   
	else 
		  local g=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm2) 
	end
end

function c33400200.frfilter(c)
	return (c:IsSetCard(0x341) or c:IsSetCard(0x340)) and c:IsFaceup() 
end
function c33400200.frtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c33400200.frfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400200.frfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c33400200.frfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c33400200.frop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	local token=Duel.CreateToken(tp,ac)
	local t1=bit.band(token:GetType(),0x7)
	local t2=bit.band(tc:GetType(),0x7)
	if t1==t2  then 
		  local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(c33400200.efilter)
				e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
				e4:SetOwnerPlayer(tp)
				e4:SetLabelObject(tc1)
				tc1:RegisterEffect(e4)   
	end
	if tc:IsCode(ac) then 
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetValue(c33400200.valcon)
			tc1:RegisterEffect(e2)
	end
end
function c33400200.efilter(e,re)   
	return re:GetOwner()~=e:GetOwner() and re:GetOwner()~=e:GetLabelObject()
end
function c33400200.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
