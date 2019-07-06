--动物朋友 东之青龙
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700082.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(33700082,1))
	Senya.AddAttackSE(c,aux.Stringid(33700082,2))
	 c:EnableReviveLimit()
	--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700082,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700082.target)
	e1:SetOperation(c33700082.operation)
	c:RegisterEffect(e1)
   --special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c33700082.lkcon)
	e0:SetOperation(c33700082.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c33700082.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c33700082.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c33700082.indtg(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,nil)
	local ct1=g:GetClassCount(Card.GetCode)
	local ct2=g:GetCount()
	return ct1<ct2 and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c33700082.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<hg then return false end
		return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
	end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700082,3))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c33700082.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700082.tfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c33700082.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.ConfirmDecktop(tp,hg)
	local g=Duel.GetDecktopGroup(tp,hg)
	if g:GetCount()>0 then
	 if g:GetClassCount(Card.GetCode)==g:GetCount() and g:IsExists(c33700082.spfilter,1,nil,e,tp) and not g:IsExists(c33700082.tfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(tp)
   else 
	  Duel.DisableShuffleCheck()
   end
end
end
function c33700082.lkfilter1(c,lc,tp)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and Duel.IsExistingMatchingCard(c33700082.lkfilter2,tp,LOCATION_MZONE,0,1,c,lc,c,tp)
end
function c33700082.lkfilter2(c,lc,mc,tp)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
		and not c:IsCode(mc:GetCode())
		and not c:IsRace(mc:GetRace())
		and not c:IsAttribute(mc:GetAttribute())
end
function c33700082.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c33700082.lkfilter1,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c33700082.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c33700082.lkfilter1,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local g2=Duel.SelectMatchingCard(tp,c33700082.lkfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c,g1:GetFirst(),tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end