--动物朋友 南之朱雀
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700083.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(33700083,1))
	Senya.AddAttackSE(c,aux.Stringid(33700083,2))
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33700083.ffilter,2,true)
   --
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700083,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700083.tg)
	e1:SetOperation(c33700083.op)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33700083.spcon)
	e2:SetOperation(c33700083.spop)
	c:RegisterEffect(e2)
	--fusion material
   -- local e3=Effect.CreateEffect(c)
   -- e3:SetType(EFFECT_TYPE_SINGLE)
   -- e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
   -- e3:SetCode(EFFECT_FUSION_MATERIAL)
   -- e3:SetCondition(c33700083.fuscon)
	--e3:SetOperation(c33700083.fusop)
   -- c:RegisterEffect(e3)
end
function c33700083.ffilter1(c,mc)
	return c:GetLevel()==mc:GetLevel() and not c:IsRace(mc:GetRace()) and not c:IsAttribute(mc:GetAttribute())
end
function c33700083.ffilter(c,fc,sub,mg,sg)
	return c:GetLevel()>0 and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(c33700083.ffilter1,1,c,c))
end
function c33700083.spfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x442) and c:IsSummonableCard()  and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c33700083.spfilter2,1,c,fc,c,tp)
end
function c33700083.spfilter2(c,fc,mc,tp)
	return c:IsFusionSetCard(0x442) and c:IsSummonableCard() and c:IsCanBeFusionMaterial(fc) and c:GetCode()~=mc:GetCode() and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc),fc)>0
end
function c33700083.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c33700083.spfilter1,1,nil,tp,c)
end
function c33700083.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c33700083.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c33700083.spfilter2,1,1,g1:GetFirst(),c,g1:GetFirst(),tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c33700083.cfilter(c)
   return  c:IsPublic()
end
function c33700083.pfilter(c)
   return not c:IsPublic()
end
function c33700083.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	  local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	 local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return  sg:GetCount()>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,sg:GetCount(),nil) and not Duel.IsExistingMatchingCard(c33700083.cfilter,tp,LOCATION_HAND,0,1,nil)  end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700083,3))
	Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,sg:GetCount(),0,0)
end
function c33700083.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g=Duel.GetMatchingGroup(c33700083.pfilter,tp,LOCATION_HAND,0,nil)
	if sg:GetCount()~=g:GetCount() then return end
	Duel.ConfirmCards(1-tp,sg)
	if  sg:GetClassCount(Card.GetCode)==sg:GetCount() then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		local ct=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
		local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,nil)
		if ct>0 and tg:GetCount()>=ct then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sel=tg:Select(tp,ct,ct,nil)
			Duel.SendtoHand(sel,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sel)
		end
	end
end