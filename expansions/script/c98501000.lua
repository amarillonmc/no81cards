--十二次元创造神 超融合神
function c98501000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--link summon
	c:SetUniqueOnField(1,0,98501000)
	aux.AddLinkProcedure(c,c98501000.mfilter,6,6,c98501000.lcheck)
	aux.AddXyzProcedureLevelFree(c,c98501000.mfilter,c98501000.lcheck,6,6)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.penlimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98501000,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c98501000.hspcon)
	e1:SetTarget(c98501000.hsptg)
	e1:SetOperation(c98501000.hspop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(98501000,1))
	e2:SetOperation(c98501000.hspop2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(98501000,2))
	e3:SetCondition(c98501000.hspcon3)
	e3:SetTarget(c98501000.hsptg3)
	e3:SetOperation(c98501000.hspop3)
	c:RegisterEffect(e3)
	---spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98501000,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98501000)
	e5:SetCondition(c98501000.spcon)
	e5:SetCost(c98501000.spcost)
	e5:SetTarget(c98501000.sptg)
	e5:SetOperation(c98501000.spop)
	c:RegisterEffect(e5)
	--destroy search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98501000,4))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,98501000+1)
	e6:SetCondition(c98501000.spcon)
	e6:SetTarget(c98501000.thtg)
	e6:SetOperation(c98501000.thop)
	c:RegisterEffect(e6)
	--disable spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetCondition(c98501000.spcon)
	e7:SetTarget(c98501000.splimit)
	c:RegisterEffect(e7)
	--special summon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(98501000,3))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,98501000+2)
	e8:SetCondition(c98501000.spcon2)
	e8:SetCost(c98501000.spcost2)
	e8:SetTarget(c98501000.sptg2)
	e8:SetOperation(c98501000.spop2)
	c:RegisterEffect(e8)
	--destroy search
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(98501000,4))
	e9:SetCategory(CATEGORY_TOHAND)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,98501000+3)
	e9:SetCondition(c98501000.spcon2)
	e9:SetTarget(c98501000.thtg2)
	e9:SetOperation(c98501000.thop2)
	c:RegisterEffect(e9)
	--disable spsummon
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(0,1)
	e10:SetCondition(c98501000.spcon2)
	e10:SetTarget(c98501000.splimit2)
	c:RegisterEffect(e10)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(98501000,3))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,98501000+4)
	e11:SetCondition(c98501000.spcon3)
	e11:SetCost(c98501000.spcost3)
	e11:SetTarget(c98501000.sptg3)
	e11:SetOperation(c98501000.spop3)
	c:RegisterEffect(e11)
	--destroy search
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(98501000,4))
	e12:SetCategory(CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,98501000+5)
	e12:SetCondition(c98501000.spcon3)
	e12:SetTarget(c98501000.thtg3)
	e12:SetOperation(c98501000.thop3)
	c:RegisterEffect(e12)
	--disable spsummon
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e13:SetTargetRange(0,1)
	e13:SetCondition(c98501000.spcon3)
	e13:SetTarget(c98501000.splimit3)
	c:RegisterEffect(e13)
	--special summon
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(98501000,3))
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1,98501000+6)
	e14:SetCondition(c98501000.spcon4)
	e14:SetCost(c98501000.spcost4)
	e14:SetTarget(c98501000.sptg4)
	e14:SetOperation(c98501000.spop4)
	c:RegisterEffect(e14)
	--destroy search
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(98501000,4))
	e15:SetCategory(CATEGORY_TOHAND)
	e15:SetType(EFFECT_TYPE_IGNITION)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCountLimit(1,98501000+7)
	e15:SetCondition(c98501000.spcon4)
	e15:SetTarget(c98501000.thtg4)
	e15:SetOperation(c98501000.thop4)
	c:RegisterEffect(e15)
	--disable spsummon
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e16:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e16:SetTargetRange(0,1)
	e16:SetCondition(c98501000.spcon4)
	e16:SetTarget(c98501000.splimit4)
	c:RegisterEffect(e16)
	--remove overlay replace
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCondition(c98501000.rcon)
	e17:SetOperation(c98501000.rop)
	c:RegisterEffect(e17)
	--special summon
	local e18=Effect.CreateEffect(c)
	e18:SetDescription(aux.Stringid(98501000,3))
	e18:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e18:SetType(EFFECT_TYPE_IGNITION)
	e18:SetRange(LOCATION_MZONE)
	e18:SetCountLimit(1,98501000+8)
	e18:SetCondition(c98501000.spcon5)
	e18:SetCost(c98501000.spcost5)
	e18:SetTarget(c98501000.sptg5)
	e18:SetOperation(c98501000.spop5)
	c:RegisterEffect(e18)
	--destroy search
	local e19=Effect.CreateEffect(c)
	e19:SetDescription(aux.Stringid(98501000,4))
	e19:SetCategory(CATEGORY_TOHAND)
	e19:SetType(EFFECT_TYPE_IGNITION)
	e19:SetRange(LOCATION_MZONE)
	e19:SetCountLimit(1,98501000+9)
	e19:SetCondition(c98501000.spcon5)
	e19:SetTarget(c98501000.thtg5)
	e19:SetOperation(c98501000.thop5)
	c:RegisterEffect(e19)
	--disable spsummon
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e20:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e20:SetTargetRange(0,1)
	e20:SetCondition(c98501000.spcon5)
	e20:SetTarget(c98501000.splimit5)
	c:RegisterEffect(e20)
	--to pzone
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(98501000,5))
	e21:SetCategory(CATEGORY_DESTROY)
	e21:SetType(EFFECT_TYPE_IGNITION)
	e21:SetRange(LOCATION_MZONE)
	e21:SetTarget(c98501000.tptg)
	e21:SetOperation(c98501000.tpop)
	c:RegisterEffect(e21)
	--immune
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_IMMUNE_EFFECT)
	e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e22:SetRange(LOCATION_MZONE)
	e22:SetValue(c98501000.efilter)
	c:RegisterEffect(e22)
	--
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_SINGLE)
	e23:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e23:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e23:SetRange(LOCATION_MZONE)
	e23:SetValue(1)
	c:RegisterEffect(e23)
	--Atk
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_SINGLE)
	e24:SetCode(EFFECT_MATERIAL_CHECK)
	e24:SetValue(c98501000.matcheck)
	c:RegisterEffect(e24)
	--win
	local e25=Effect.CreateEffect(c)
	e25:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e25:SetCode(EVENT_ADJUST)
	e25:SetRange(LOCATION_MZONE)
	e25:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e25:SetOperation(c98501000.winop)
	c:RegisterEffect(e25)
	--scale
	local e26=Effect.CreateEffect(c)
	e26:SetDescription(aux.Stringid(98501000,6))
	e26:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e26:SetType(EFFECT_TYPE_IGNITION)
	e26:SetRange(LOCATION_PZONE)
	e26:SetCountLimit(1,98501000+10)
	e26:SetTarget(c98501000.pvtg)
	e26:SetOperation(c98501000.pvop)
	c:RegisterEffect(e26)
	--not
	local e27=Effect.CreateEffect(c)
	e27:SetType(EFFECT_TYPE_FIELD)
	e27:SetRange(LOCATION_PZONE)
	e27:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e27:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e27:SetTargetRange(0,1)
	e27:SetCondition(c98501000.spcon6)
	e27:SetTarget(c98501000.splimit6)
	c:RegisterEffect(e20)
end
c98501000.pendulum_level=12
function c98501000.mfilter(c)
	return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
end
function c98501000.lcheck(g,lc)
	return g:GetClassCount(Card.GetType)==g:GetCount()
end
c98501000.spchecks=aux.CreateChecks(Card.IsType,{TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK})
function c98501000.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(Card.IsType,nil,TYPE_MONSTER)
	return g:CheckSubGroupEach(c98501000.spchecks,aux.mzctcheckrel,tp,REASON_SPSUMMON)
end
function c98501000.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(Card.IsType,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroupEach(tp,c98501000.spchecks,true,aux.mzctcheckrel,tp,REASON_SPSUMMON)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c98501000.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		local tatk=tc:GetBaseAttack()
		local tdef=tc:GetBaseDefense()
		local code=tc:GetCode()
		atk=atk+tatk
		def=def+tdef
		c:CopyEffect(code,RESET_EVENT+RESET_TODECK,0)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
	g:DeleteGroup()
	e:GetHandler():RegisterFlagEffect(98501000,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
end
function c98501000.hspop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		local tatk=tc:GetBaseAttack()
		local tdef=tc:GetBaseDefense()
		local code=tc:GetCode()
		atk=atk+tatk
		def=def+tdef
		c:CopyEffect(code,RESET_EVENT+RESET_TODECK,0)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
	g:DeleteGroup()
	e:GetHandler():RegisterFlagEffect(98501000+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
end
c98501000.material_type=TYPE_SYNCHRO
function c98501000.fusfilter1(c)
	return c:IsFusionType(TYPE_FUSION)
end
function c98501000.fusfilter2(c)
	return c:IsFusionType(TYPE_SYNCHRO)
end
function c98501000.fusfilter3(c)
	return c:IsFusionType(TYPE_XYZ)
end
function c98501000.fusfilter4(c)
	return c:IsFusionType(TYPE_PENDULUM)
end
function c98501000.fusfilter5(c)
	return c:IsFusionType(TYPE_RITUAL)
end
function c98501000.fusfilter6(c)
	return c:IsFusionType(TYPE_LINK)
end
function c98501000.rfilter(c,tp)
	return c:IsType(TYPE_TUNER) and (c:IsControler(tp) or c:IsFaceup())
end
function c98501000.fselect(g,tp)
	return g:IsExists(c98501000.rfilter,1,nil,tp) and aux.mzctcheckrel(g,tp,REASON_SPSUMMON)
end
function c98501000.hspcon3(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(Card.IsType,nil,TYPE_MONSTER)
	return g:CheckSubGroupEach(c98501000.spchecks,c98501000.fselect,tp)
end
function c98501000.hsptg3(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(Card.IsType,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroupEach(tp,c98501000.spchecks,true,c98501000.fselect,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c98501000.hspop3(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		local tatk=tc:GetBaseAttack()
		local tdef=tc:GetBaseDefense()
		local code=tc:GetCode()
		atk=atk+tatk
		def=def+tdef
		c:CopyEffect(code,RESET_EVENT+RESET_TODECK,0)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
	e:GetHandler():RegisterFlagEffect(98501000+2,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
end
function c98501000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98501000)>0
end
function c98501000.costfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c98501000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98501000.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98501000.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c98501000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98501000.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():RegisterFlagEffect(98501000+5,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		g:GetFirst():CompleteProcedure()
	end
end
function c98501000.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c98501000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98501000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c98501000.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98501000+1)>0
end
function c98501000.costfilter2(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c98501000.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.costfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98501000.costfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98501000.spfilter2(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
end
function c98501000.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98501000.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.spfilter2),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():RegisterFlagEffect(98501000+5,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		g:GetFirst():CompleteProcedure()
	end
end
function c98501000.thfilter2(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c98501000.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.thfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.thfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98501000.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98501000.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98501000+2)>0
end
function c98501000.costfilter3(c)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c98501000.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.costfilter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98501000.costfilter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98501000.spfilter3(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false)
end
function c98501000.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98501000.spfilter3,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.spfilter3),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():RegisterFlagEffect(98501000+5,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		g:GetFirst():CompleteProcedure()
	end
end
function c98501000.thfilter3(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c98501000.thtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.thfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.thop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.thfilter3),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98501000.splimit3(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c98501000.spcon4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98501000.costfilter4(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c98501000.spcost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.costfilter4,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98501000.costfilter4,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98501000.spfilter4(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c98501000.sptg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98501000.spfilter4,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.overfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c98501000.spop4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.spfilter4),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.overfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
		if og:GetCount()>0 then
			Duel.Overlay(g:GetFirst(),og)
		end
		g:GetFirst():RegisterFlagEffect(98501000+5,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		g:GetFirst():CompleteProcedure()
	end
end
function c98501000.thfilter4(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function c98501000.thtg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.thfilter4,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.thop4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.thfilter4),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98501000.splimit4(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c98501000.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and ep==e:GetOwnerPlayer() and re:GetActivateLocation()&LOCATION_MZONE~=0
end
function c98501000.rop(e,tp,eg,ep,ev,re,r,rp)
	return ev
end
function c98501000.spcon5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98501000.costfilter5(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c98501000.spcost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.costfilter5,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98501000.costfilter5,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98501000.spfilter5(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,false)
end
function c98501000.sptg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98501000.spfilter5,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.spop5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.spfilter5),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():RegisterFlagEffect(98501000+5,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		g:GetFirst():CompleteProcedure()
	end
end
function c98501000.thfilter5(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function c98501000.thtg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.thfilter5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98501000.thop5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98501000.thfilter5),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c98501000.splimit5(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c98501000.tpfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c98501000.tptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.tpfilter,tp,LOCATION_PZONE,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c98501000.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c98501000.tpfilter,tp,LOCATION_PZONE,0,1,1,nil):GetFirst()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		if c:IsRelateToEffect(e) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c98501000.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98501000.matcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		local tatk=tc:GetBaseAttack()
		local tdef=tc:GetBaseDefense()
		local code=tc:GetCode()
		atk=atk+tatk
		def=def+tdef
		c:CopyEffect(code,RESET_EVENT+RESET_TODECK,0)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
end
function c98501000.winfilter(c)
	return c:GetFlagEffect(98501000+5)>0
end
function c98501000.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_VENNOMINAGA=0x985
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c98501000.winfilter,tp,LOCATION_MZONE,0,4,nil) then
		Duel.Win(tp,WIN_REASON_VENNOMINAGA)
	end
end
function c98501000.scalefilter(c)
	return c:IsFaceup()
end
function c98501000.pvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98501000.scalefilter,tp,LOCATION_PZONE,0,1,nil) end
end
function c98501000.pvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c98501000.scalefilter,tp,LOCATION_PZONE,0,1,1,nil):GetFirst()
	local t={}
	local p=1
	for i=0,13 do
		if i~=tc:GetLeftScale() then
			t[p]=i
			p=p+1
		end
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(ac)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	tc:RegisterEffect(e2)
end
function c98501000.spcon6(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c98501000.splimit6(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
