--界限龙 阿勒克托
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND,rscon.excard(rscf.FilterFaceUp(Card.IsSetCard,0x1337),LOCATION_MZONE),nil,rstg.target(rsop.list(cm.spfilter,"sp")),cm.spop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},nil,"de,tg",nil,nil,cm.copytg,cm.copyop)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then
		rssf.SpecialSummon(c)
	end
end
function cm.copyfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c.rs_ghostdom_dragon_effect or not c:IsOriginalSetCard(0x337) or c:GetOriginalLevel()~=4 or c:IsCode(m) or c:IsFacedown() then return false end
	local e1=c.rs_ghostdom_dragon_effect[1]
	local e2=c.rs_ghostdom_dragon_effect[2]
	local target1=e1:GetTarget()
	local target2=e2:GetTarget()
	if not target1 or target1(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	if not target2 or target2(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	return false 
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return cm.copyfilter(chkc,e,tp,eg,ep,ev,re,r,rp)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.copyfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,cm.copyfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	local e1=tc.rs_ghostdom_dragon_effect[1]
	local e2=tc.rs_ghostdom_dragon_effect[2]
	local target1=e1:GetTarget()
	local target2=e2:GetTarget()
	local b1=not target1 or target1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=not target2 or target2(e,tp,eg,ep,ev,re,r,rp,0)
	local op=rsof.SelectOption(tp,b1,e1:GetDescription(),b2,e2:GetDescription())
	local te=e2
	if op==1 then te=e1 end 
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty()|EFFECT_FLAG_CARD_TARGET)
	local tg=te:GetTarget()
	if tg then
	   tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
