--凶导的白死徒
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--send to gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	--extra deck ritual material
	if not s.globle_check then
		--chain check
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(s.chainop)
		Duel.RegisterEffect(e1,0)
		--
		s.globle_check=true
		WD_hack_ritual_check=aux.RitualUltimateFilter
		function Auxiliary.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
			local exg=Group.CreateGroup()
			if c:GetOriginalCode()==id then
				exg=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_EXTRA,0,nil,c)
				if exg:GetCount()>0 then
					local g=Group.__add(exg,m1)
					if Duel.GetFlagEffect(tp,id+1)~=0 then
						Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_CHAIN,0,1)
					end
					return WD_hack_ritual_check(c,filter,e,tp,g,m2,level_function,greater_or_equal,chk)
				end
			end
			return WD_hack_ritual_check(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
		end
		WD_hack_ritual_mat_filter=Group.Filter
		function Group.Filter(group,filter,card_or_group_or_nil,...)
			local exg=Group.CreateGroup()
			if card_or_group_or_nil and aux.GetValueType(card_or_group_or_nil)=="Card" and card_or_group_or_nil:GetOriginalCode()==id and Duel.GetFlagEffect(tp,id+1)~=0 and Duel.GetFlagEffect(tp,id)~=0 then
				exg=Duel.GetMatchingGroup(s.filter0,card_or_group_or_nil:GetControler(),LOCATION_EXTRA,0,nil,c)
				group:Merge(exg)
			end
			return WD_hack_ritual_mat_filter(group,filter,card_or_group_or_nil,...)
		end
	end
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id+1,RESET_EVENT+RESET_CHAIN,0,1)
end
function s.filter0(c,rc)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsCanBeRitualMaterial(rc)
end
function s.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL~=SUMMON_TYPE_RITUAL or (se and se:GetHandler():IsSetCard(0x145))
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and Duel.IsExistingMatchingCard(s.tgfilter0,c:GetControler(),0,LOCATION_EXTRA,1,nil,tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.tgfilter0(c,tp)
	if c:IsControler(tp) then
		return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
	else
		return Duel.IsPlayerCanSendtoGrave(tp,c)
	end
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eg=eg:Filter(s.cfilter,nil,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter0,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,tp) and #eg>0 end
	local pl=2
	if eg:IsExists(Card.IsControler,1,nil,tp) then pl=tp end
	if eg:IsExists(Card.IsControler,1,nil,1-tp) then if pl==tp then pl=3 else pl=1-tp end end
	eg:KeepAlive()
	e:SetLabelObject(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,pl,LOCATION_EXTRA)
end
function s.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g1==0 and #g2==0 then return end
	local eg=e:GetLabelObject()
	local eg=eg:Filter(s.cfilter,nil,tp)
	local g=Group.CreateGroup()
	if eg:IsExists(Card.IsControler,1,nil,tp) then
		Duel.ConfirmCards(tp,g2)
		g:Merge(g2) 
	end
	if eg:IsExists(Card.IsControler,1,nil,1-tp) then
		g:Merge(g1) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,s.tgfilter,1,eg:GetCount(),nil)
	if #sg>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if sg:IsExists(Card.IsControler,1,nil,1-tp) then
		Duel.ShuffleExtra(1-tp)
	end
end
