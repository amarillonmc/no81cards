--神造遗物的恶逆 伊莉斯

function c72409110.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,nil,3,4,c72409110.lcheck)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72409110,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,72409110)
	e1:SetCondition(c72409110.LinkCondition(c72409110.filter2,1,1))
	e1:SetTarget(c72409110.LinkTarget(c72409110.filter2,1,1))
	e1:SetOperation(c72409110.LinkOperation(c72409110.filter2,1,1))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72409110,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c72409110.condition)
	e2:SetTarget(c72409110.thtg)
	e2:SetOperation(c72409110.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(72409155)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c72409110.desreptg)
	e4:SetOperation(c72409110.desrepop)
	c:RegisterEffect(e4)
--
end
function c72409110.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xe729)
end
--
function c72409110.filter2(c)
	return c:IsCode(72409035)
end
function c72409110.LCheckGoal(sg,tp,lc,gf)
	return sg:CheckWithSumEqual(aux.GetLinkCount,1,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(aux.LUncompatibilityFilter,1,nil,sg,lc)
end
function c72409110.LinkCondition(f,minc,maxc,gf)
	return
	function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=aux.GetLinkMaterials(tp,f,c)
		local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(fg)
		return mg:CheckSubGroup(c72409110.LCheckGoal,min,max,tp,c,gf)
	end
end
function c72409110.LinkTarget(f,minc,maxc,gf)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=aux.GetLinkMaterials(tp,f,c)
		local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		Duel.SetSelectedCard(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local cancel=Duel.GetCurrentChain()==0
		local sg=mg:SelectSubGroup(tp,c72409110.LCheckGoal,cancel,min,max,tp,c,gf)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
function c72409110.LinkOperation(f,min,max,gf)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
		g:DeleteGroup()
		local e0_1=Effect.CreateEffect(c)
		e0_1:SetType(EFFECT_TYPE_SINGLE)
		e0_1:SetCode(72409110)
		e0_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0_1:SetValue(1)
		e0_1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e0_1,true)
		local e0_2=Effect.CreateEffect(c)
		e0_2:SetType(EFFECT_TYPE_SINGLE)
		e0_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e0_2:SetValue(1)
		e0_2:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e0_2,true)
	end
end
--
function c72409110.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not e:GetHandler():IsHasEffect(72409110)
end
function c72409110.eqfilter(c,e,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x6729) and c:CheckEquipTarget(e:GetOwner()) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c72409110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72409110.eqfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c72409110.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c72409110.eqfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local n=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if Duel.Equip(tp,g:GetFirst(),e:GetOwner()) and n~=0 and Duel.IsExistingMatchingCard(c72409110.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(72409110,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local gq=Duel.GetMatchingGroup(c72409110.eqfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if gq:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local gqe=gq:SelectSubGroup(tp,aux.dncheck,false,1,n)
			local tg=Group.GetFirst(gqe)
			while tg do
			Duel.Equip(tp,tg,e:GetOwner())
			tg=Group.GetNext(gqe)
			end
		end
	end
end
function c72409110.repfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c72409110.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c72409110.repfilter,1,nil)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,c72409110.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c72409110.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
