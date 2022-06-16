local m=31400112
local cm=_G["c"..m]
cm.name="真龙皇 十二炼机圣"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)
	e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetTarget(cm.mattg)
	e5:SetValue(cm.matval)
	c:RegisterEffect(e5)
	if not aux.link_mat_hack_check then
		aux.link_mat_hack_check=true
		_IsCanBeLinkMaterial=Card.IsCanBeLinkMaterial
		function Card.IsCanBeLinkMaterial(c,lc)
			if c:GetOriginalType()&TYPE_MONSTER~=0 then
				return _IsCanBeLinkMaterial(c,lc)
			end
			if c:IsForbidden() then return false end
			local le={c:IsHasEffect(EFFECT_CANNOT_BE_LINK_MATERIAL)}
			for _,te in pairs(le) do
				local tf=te:GetValue()
				local tval=tf(te,lc)
				if tval then return false end
			end
			return true
		end
	end
	if not aux.get_link_mat_hack_check then
		aux.get_link_mat_hack_check=true
		function aux.GetLinkMaterials(tp,f,lc,e)
			local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_ONFIELD,0,nil,f,lc,e)
			local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
			return mg
		end
	end
end
function cm.lcheckc(c)
	if c:IsType(TYPE_MONSTER) then
		return c:GetLinkAttribute()
	end
	if c:IsType(TYPE_SPELL) then
		return 0x80
	end
	return 0x100
end
function cm.lcheck2(c)
	local con1=c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEDOWN_DEFENSE)
	local con2=c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsType(TYPE_CONTINUOUS+TYPE_TRAPMONSTER)
	return con1 or con2 or con3
end
function cm.lcheck(g)
	return g:GetClassCount(cm.lcheckc)==g:GetCount() and g:FilterCount(cm.lcheck2,nil)==0
end
function cm.mattg(e,c)
	return c:IsType(TYPE_CONTINUOUS)
end
function cm.matval(e,lc,mg,c,tp)
	return true,true
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.efilter)
	e1:SetLabel(typ)
	c:RegisterEffect(e1)
	if bit.band(typ,TYPE_MONSTER)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	if bit.band(typ,TYPE_SPELL)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if bit.band(typ,TYPE_TRAP)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
end
function cm.efilter(e,te)
	return te:GetHandler():GetOriginalType()&e:GetLabel()~=0 and te:GetOwner()~=e:GetOwner()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.con(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.STsetfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.Msetfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.tgfilter(c,e,tp)
	local con1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and cm.STsetfilter(c)
	local con2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cm.Msetfilter(c,e,tp)
	local con3=c:IsAbleToHand()
	return con1 or con2 or con3
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0xf9)
	if chk==0 then return tg:FilterCount(cm.tgfilter,nil,e,tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.advfilter(c)
	return c:IsSetCard(0xf9) and c:IsSummonable(true,nil,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0xf9):Filter(cm.tgfilter,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	local res
	if tc then
		local con1=tc:IsAbleToHand()
		local con2=cm.STsetfilter(tc) or cm.Msetfilter(tc,e,tp)
		if con1 and (not con2 or Duel.SelectOption(tp,1190,1153)==0) then
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if cm.STsetfilter(tc) then
				res=Duel.SSet(tp,tc)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				tc:RegisterEffect(e2)
			else
				res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
	if res>0 and Duel.IsExistingMatchingCard(cm.advfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		local advc=Duel.GetMatchingGroup(cm.advfilter,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil):GetFirst()
		Duel.Summon(tp,advc,true,nil,1)
	end
end