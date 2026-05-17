--底噪石窟的燃烧黄昏 史尔特尔
local s,id,o=GetID()
local SET_BOTTOMNOISE=0x5d71

s.copyinfo={}

function s.initial_effect(c)
	--global check
	s.globalcheck(c)

	--① 对方把怪兽的效果发动的场合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--② End Phase add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

--global check for destroyed "底噪石" Spell
function s.globalcheck(c)
	if s.global_checked then return end
	s.global_checked=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_DESTROYED)
	ge1:SetOperation(s.checkop)
	Duel.RegisterEffect(ge1,0)
end

function s.checkfilter(c)
	return c:IsReason(REASON_DESTROY)
		and c:IsSetCard(SET_BOTTOMNOISE)
		and c:IsType(TYPE_SPELL)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.checkfilter,1,nil) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,1)
	end
end

--①
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end

function s.getcopyinfo(c,e,tp)
	--不无视发动条件，只无视cost，只取那张速攻魔法的“发动时效果”
	local te,ceg,cep,cev,cre,cr,crp=c:CheckActivateEffect(false,true,true)
	if not te then return nil end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,ceg,cep,cev,cre,cr,crp,0) then
		return nil
	end
	return te,ceg,cep,cev,cre,cr,crp
end

function s.costfilter(c,e,tp,ft)
	return c:IsSetCard(SET_BOTTOMNOISE)
		and c:IsType(TYPE_QUICKPLAY)
		and c:IsAbleToGraveAsCost()
		and (ft>0 or c:IsLocation(LOCATION_MZONE))
		and s.getcopyinfo(c,e,tp)~=nil
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp,ft)
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()

	local te,ceg,cep,cev,cre,cr,crp=s.getcopyinfo(tc,e,tp)
	s.copyinfo[e:GetFieldID()]={
		te=te,
		ceg=ceg,
		cep=cep,
		cev=cev,
		cre=cre,
		cr=cr,
		crp=crp
	}

	Duel.SendtoGrave(g,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (ft>0 or Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,0))
	end

	local info=s.copyinfo[e:GetFieldID()]
	if info and info.te then
		local tg=info.te:GetTarget()
		if tg then
			tg(e,tp,info.ceg,info.cep,info.cev,info.cre,info.cr,info.crp,1)
		end
		info.te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(info.te)
	end

	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local info=s.copyinfo[e:GetFieldID()]
	s.copyinfo[e:GetFieldID()]=nil

	local te=e:GetLabelObject() or (info and info.te)

	if not (c:IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then
		return
	end

	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then
			op(e,tp,
				(info and info.ceg) or eg,
				(info and info.cep) or ep,
				(info and info.cev) or ev,
				(info and info.cre) or re,
				(info and info.cr) or r,
				(info and info.crp) or rp)
		end
	end
end

--②
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
		and e:GetHandler():IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
