--深层空想 死域之海
local m=10122015
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.GraveDestroyActivateEffect(c,m)
	local e3=rsef.QO(c,nil,{m,0},1,"tk,sp",nil,LOCATION_FZONE,nil,rscost.reglabel(100),cm.tg,nil,rsul.hint)	  
end
function cm.cfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc333) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=100 then return false end
	   return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) and rsul.SpecialOrPlaceBool(tp)
	end
	local ct=rsul.SpecialOrPlaceBool(tp,nil,2) and 2 or 1
	rsof.SelectHint(tp,"rm")
	local rg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,ct,nil,tp)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetOperation(rsul.TokenOp(rsul.advtkop,nil,#rg))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end

