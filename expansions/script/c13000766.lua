local s,id=GetID()
function c13000766.initial_effect(c)
	  --synchro summon
	c:SetSPSummonOnce(13000766)
	local e0=s.AddLinkProcedure(c,nil,3,5)
	c:EnableReviveLimit()

local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13000766,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(s.descon)
	--e3:SetCost(s.cost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	if s.global==nil then --添加全局效果并注册给1个玩家
		s.global=true
		local e13=Effect.CreateEffect(c)
		e13:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e13:SetCode(EVENT_CHANGE_POS)
		e13:SetOperation(s.globals)
		Duel.RegisterEffect(e13,0)
	end
end
s.num=0
function s.globals(e,tp,eg,ep,ev,re,r,rp)--添加标识
	local g=eg:Filter(s.cfilter2,nil,tp)--筛选自己盖放的卡
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id+rp,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
	end
end
function s.cfilter2(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
			and c:IsPosition(POS_FACEDOWN)
end
function s.AddLinkProcedure(c,f,min,max,gf)
	if max==nil then max=c:GetLink() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.LinkCondition(f,min,max,gf))
	e1:SetTarget(s.LinkTarget(f,min,max,gf))
	e1:SetOperation(s.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	return e1
end
function s.LinkCondition(f,minct,maxct,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
					local mg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
					local mg3=Duel.GetMatchingGroup(s.filter,tp,LOCATION_SZONE,0,nil)
					mg:Merge(mg2)
					mg:Merge(mg3)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(s.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function s.LinkTarget(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
					local mg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
					local mg3=Duel.GetMatchingGroup(s.filter,tp,LOCATION_SZONE,0,nil)
					mg:Merge(mg2)
					mg:Merge(mg3)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,s.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function s.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg,lc,tp))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat)) and sg:FilterCount(s.link,nil)<=2
end
function s.link(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
end
function s.LinkOperation(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function s.chainlm(e,ep,tp)
	return tp==ep
end
function s.filter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and not c:IsFacedown()
end
function s.filter2(c,tp)
	return c:IsFacedown() and c:GetFlagEffect(id+tp)~=0
end
function s.mattg(e,c,tp)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function s.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function s.matval2(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(s.filter2,1,nil,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local aa=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,tp)
	if e:GetHandler():GetFlagEffect(13000766)>0 then Duel.SetChainLimit(s.chainlm) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.num=s.num+1
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(s.atkval)
		e2:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e2)
		if Duel.SelectYesNo(tp,aux.Stringid(13000766,0)) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if not tc:IsLocation(LOCATION_REMOVED) then
			local aa=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil)
			Duel.SendtoDeck(aa,nil,0,REASON_EFFECT)  
		end
	end
end
function s.atkval(e,c)
	return s.num*1000
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local c=e:GetHandler()
	local a=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if Duel.Destroy(a,REASON_COST)~0 and a:IsSummonLocation(LOCATION_EXTRA) then
		c:RegisterFlagEffect(13000766,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if e:GetHandler():GetFlagEffect(13000766)>0 then Duel.SetChainLimit(s.chainlm) end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end







