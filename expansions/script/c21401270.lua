--底噪石窟
local s,id,o=GetID()
local SET_BOTTOMNOISE=0x5d71
local CHAIN_FLAG=id+100
local TYPES_NORMAL_SPELL_MONSTER=TYPE_MONSTER+TYPE_NORMAL+TYPE_SPELL+TYPE_QUICKPLAY

s.copyinfo={}

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--① copy activation effect, then Special Summon that Quick-Play Spell as a monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.cpcon)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
	c:RegisterEffect(e2)

	--② return banished "底噪石" cards to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.rthtg)
	e3:SetOperation(s.rthop)
	c:RegisterEffect(e3)
end

--①
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

function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(CHAIN_FLAG)==0
		and eg:IsExists(s.cpfilter,1,nil,e,tp)
end

function s.cpfilter(c,e,tp)
	return c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
		and c:IsSetCard(SET_BOTTOMNOISE)
		and c:IsType(TYPE_QUICKPLAY)
		and c:IsCanBeEffectTarget(e)
		and Duel.GetFlagEffect(tp,id+c:GetCode())==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(
			tp,c:GetCode(),SET_BOTTOMNOISE,TYPES_NORMAL_SPELL_MONSTER,
			3000,3000,2,RACE_ROCK,ATTRIBUTE_EARTH
		)
		and s.getcopyinfo(c,e,tp)~=nil
end

function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and s.cpfilter(chkc,e,tp)
	end
	if chk==0 then
		return eg:IsExists(s.cpfilter,1,nil,e,tp)
	end

	local c=e:GetHandler()
	c:RegisterFlagEffect(CHAIN_FLAG,RESET_CHAIN,0,1)

	local g=eg:Filter(s.cpfilter,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	Duel.SetTargetCard(sg)

	local te,ceg,cep,cev,cre,cr,crp=s.getcopyinfo(tc,e,tp)
	if te then
		local tg=te:GetTarget()
		if tg then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		s.copyinfo[e:GetFieldID()]={
			tc=tc,
			te=te,
			ceg=ceg,
			cep=cep,
			cev=cev,
			cre=cre,
			cr=cr,
			crp=crp
		}
	end

	--这个回合，不能再为这个卡名的这个效果以相同卡名的卡为对象
	Duel.RegisterFlagEffect(tp,id+tc:GetCode(),RESET_PHASE+PHASE_END,0,1)

	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local info=s.copyinfo[e:GetFieldID()]
	s.copyinfo[e:GetFieldID()]=nil

	local tc=(info and info.tc) or Duel.GetFirstTarget()
	local te=e:GetLabelObject() or (info and info.te)

	--把那张卡发动时的效果适用
	if te then
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

	--那之后，那张卡变成通常怪兽特殊召唤，也当作魔法卡使用
	if tc and tc:IsRelateToEffect(e)
		and tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		and (not tc:IsLocation(LOCATION_REMOVED) or tc:IsFaceup())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(
			tp,tc:GetCode(),SET_BOTTOMNOISE,TYPES_NORMAL_SPELL_MONSTER,
			3000,3000,2,RACE_ROCK,ATTRIBUTE_EARTH
		) then
		Duel.BreakEffect()
		tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL+TYPE_QUICKPLAY,ATTRIBUTE_EARTH,RACE_ROCK,2,3000,3000)
		Duel.SpecialSummon(tc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end

--②
function s.rthfilter(c)
	return c:IsSetCard(SET_BOTTOMNOISE) and c:IsAbleToHand()
end

function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE)
			and s.rthfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.rthfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.rthfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end

function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and #g>0 then
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
